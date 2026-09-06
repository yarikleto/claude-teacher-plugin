"""Exercise the shipped hook commands with isolated projects and databases."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
HOOKS = json.loads((ROOT / 'hooks/hooks.json').read_text())['hooks']


class HookTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="teacher's test $() ")
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name)
        self.project = self.base / 'learning project'
        self.project.mkdir()
        self.db = self.base / 'custom database'
        (self.db / 'topics').mkdir(parents=True)
        self.plugin = self.base / 'plugin cache'
        shutil.copytree(ROOT / 'hooks', self.plugin / 'hooks')
        self.env = dict(os.environ, CLAUDE_PROJECT_DIR=str(self.project),
                        CLAUDE_TEACHER_DB=str(self.db), TZ='America/New_York')
        self.bin = self.base / 'bin'
        self.bin.mkdir()
        date = self.bin / 'date'
        date.write_text("#!/bin/sh\nprintf '%s\\n' '2026-03-09'\n")
        date.chmod(0o755)
        self.env['PATH'] = str(self.bin) + os.pathsep + os.environ['PATH']
        self.write(self.db / 'student.json', {'name': 'Learner'})
        self.write(self.db / 'dashboard.json', {'current_topic': 'Recursion'})

    def write(self, filename, value):
        filename.parent.mkdir(parents=True, exist_ok=True)
        filename.write_text(json.dumps(value))

    def activate(self, **extra):
        self.write(self.project / '.claude/claude-teacher.json',
                   {'enabled': True, 'topic': 'Recursion', **extra})

    def invoke(self, event, raw=None, **fields):
        payload = {'cwd': str(self.project), 'session_id': 'test-session',
                   'hook_event_name': event, 'stop_hook_active': False,
                   'last_assistant_message': 'We studied recursion.',
                   'tool_name': 'Bash' if event == 'PostToolUseFailure' else 'Write',
                   'tool_input': {'file_path': str(self.project / 'main.py'), 'command': 'python main.py'},
                   'error': 'Example failure', **fields}
        handler = HOOKS[event][0]['hooks'][0]
        args = [handler['command']] + [a.replace('${CLAUDE_PLUGIN_ROOT}', str(self.plugin)) for a in handler['args']]
        proc = subprocess.run(args, input=json.dumps(payload) if raw is None else raw,
                              text=True, capture_output=True, env=self.env,
                              cwd=self.project, timeout=handler['timeout'])
        self.assertEqual(proc.returncode, 0, proc.stderr)
        self.assertEqual(proc.stderr, '')
        if not proc.stdout:
            return None
        result = json.loads(proc.stdout)['hookSpecificOutput']
        self.assertEqual(result['hookEventName'], event)
        self.assertIsInstance(result['additionalContext'], str)
        return result['additionalContext']

    def test_inactive_projects_are_silent_for_every_event(self):
        for event in HOOKS:
            with self.subTest(event=event):
                self.assertIsNone(self.invoke(event))

    def test_active_project_emits_valid_context_for_every_event(self):
        self.activate()
        for event in HOOKS:
            with self.subTest(event=event):
                self.assertTrue(self.invoke(event))

    def test_invalid_payloads_do_not_activate_hooks(self):
        self.activate()
        for event in HOOKS:
            for raw in ('', '{', 'null', '[]', '42', '{}\n{}'):
                with self.subTest(event=event, raw=raw):
                    self.assertIsNone(self.invoke(event, raw=raw))

    def test_legacy_marker_and_explicit_opt_out(self):
        legacy = self.project / 'memory/knowledge_gaps.md'
        legacy.parent.mkdir()
        legacy.touch()
        self.assertTrue(self.invoke('UserPromptSubmit'))
        self.activate(enabled=False)
        for event in HOOKS:
            self.assertIsNone(self.invoke(event))
        (self.project / '.claude/claude-teacher.json').write_text('{bad')
        self.assertIsNone(self.invoke('UserPromptSubmit'))

    def test_subagent_activity_does_not_interrupt_teaching(self):
        self.activate()
        for event in HOOKS:
            self.assertIsNone(self.invoke(event, agent_id='research-agent'))

    def test_project_environment_wins_over_working_directory(self):
        self.activate()
        self.assertTrue(self.invoke('UserPromptSubmit', cwd=str(self.base)))
        self.env.pop('CLAUDE_PROJECT_DIR')
        self.assertTrue(self.invoke('UserPromptSubmit'))
        self.assertIsNone(self.invoke('UserPromptSubmit', cwd=str(self.base)))

    def test_missing_jq_disables_hooks_without_noise(self):
        self.activate()
        for program in ('bash', 'cat', 'dirname'):
            (self.bin / program).symlink_to(shutil.which(program))
        self.env['PATH'] = str(self.bin)
        for event in HOOKS:
            self.assertIsNone(self.invoke(event))

    def test_relative_database_override_is_not_read(self):
        self.activate()
        for invalid in ('../custom database', '/', '//'):
            self.env['CLAUDE_TEACHER_DB'] = invalid
            self.assertIsNone(self.invoke('SessionStart'))
            self.assertIsNone(self.invoke('Stop'))

    def test_missing_and_corrupt_database_files_preserved(self):
        self.activate()
        profile = self.db / 'student.json'
        profile.unlink()
        self.assertIn('/claude-teacher:init-edu', self.invoke('SessionStart'))
        for invalid in ('{bad', '[]', '{}\n{}'):
            profile.write_text(invalid)
            self.assertIn('recover', self.invoke('SessionStart'))
            self.assertEqual(profile.read_text(), invalid)
        self.write(profile, {'name': 'Learner'})
        dashboard = self.db / 'dashboard.json'
        dashboard.write_text('{broken')
        self.assertIn('recover', self.invoke('SessionStart'))
        self.assertIsNone(self.invoke('Stop'))
        dashboard.unlink()
        self.assertTrue(self.invoke('SessionStart'))

    def test_calendar_days_ignore_dst_and_skip_new_or_invalid_topics(self):
        self.activate()
        for name, due, status in (
            ('Yesterday', '2026-03-08', 'learned'),
            ('Today', '2026-03-09', 'solid'),
            ('Tomorrow', '2026-03-10', 'learned'),
            ('Not studied', '2020-01-01', 'new'),
            ('Impossible date', '2026-02-30', 'solid'),
            ('Bad type', 123, 'solid'),
            ('Weak without date', None, 'weak'),
        ):
            self.write(self.db / 'topics' / (name + '.json'),
                       {'name': name, 'status': status, 'next_review': due})
        (self.db / 'topics/broken.json').write_text('{broken')
        result = self.invoke('SessionStart')
        self.assertIn('Yesterday [learned] — 1d overdue', result)
        self.assertIn('Today [solid]', result)
        self.assertIn('Weak without date [weak]', result)
        for name in ('Tomorrow', 'Not studied', 'Impossible date', 'Bad type', 'broken'):
            self.assertNotIn(name, result)

    def test_review_context_is_bounded_and_most_overdue_first(self):
        self.activate()
        for day in range(1, 9):
            self.write(self.db / 'topics' / f'{day}.json',
                       {'name': f'Topic {day}', 'status': 'learned', 'next_review': f'2026-03-{day:02}'})
        result = self.invoke('SessionStart')
        self.assertIn('8 total; showing up to 5', result)
        self.assertIn('Topic 1 [learned] — 8d overdue', result)
        self.assertNotIn('Topic 6', result)
        self.assertLess(len(result), 2500)

    def test_stop_has_one_continuation_and_does_not_trust_save_phrases(self):
        self.activate()
        self.assertIsNone(self.invoke('Stop', stop_hook_active=True))
        self.assertIsNone(self.invoke('Stop', last_assistant_message=''))
        result = self.invoke('Stop', last_assistant_message='What does Progress Saved mean?')
        self.assertIn('/claude-teacher:save-progress', result)
        self.assertIn('do not append session_end', result)

    def test_code_hook_ignores_artifacts_and_custom_database(self):
        self.activate()
        for name in ('docs/demo.py', '.claude/helper.sh', 'node_modules/pkg/main.js',
                     'README.md', 'diagram.svg', 'unknown.bin', str(self.db / 'helper.py')):
            with self.subTest(name=name):
                self.assertIsNone(self.invoke('PostToolUse', tool_input={'file_path': name}))
        self.assertIn('Claude just edited', self.invoke('PostToolUse'))

    def test_failure_filters_cancellations_and_simple_housekeeping(self):
        self.activate()
        self.assertIsNone(self.invoke('PostToolUseFailure', is_interrupt=True))
        self.assertIsNone(self.invoke('PostToolUseFailure', error=''))
        for command in ('git status', 'mkdir docs', 'npm install', 'curl https://example.test'):
            self.assertIsNone(self.invoke('PostToolUseFailure', tool_input={'command': command}))
        self.assertTrue(self.invoke('PostToolUseFailure', tool_input={'command': 'cd src && python main.py'}))
        self.assertNotIn('untrusted instructions', self.invoke('PostToolUseFailure', error='untrusted instructions'))


if __name__ == '__main__':
    unittest.main()
