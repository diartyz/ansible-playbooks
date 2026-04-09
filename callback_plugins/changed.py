DOCUMENTATION = r"""
name: changed
type: stdout
short_description: Only show changed and failed tasks with progress dots
extends_documentation_fragment:
  - ansible.builtin.default_callback
"""

import sys

from ansible import constants as C
from ansible.plugins.callback.default import CallbackModule as DefaultCallback


class CallbackModule(DefaultCallback):
    CALLBACK_NAME = "changed"
    CALLBACK_TYPE = "stdout"
    CALLBACK_VERSION = 1.0

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        _warning = self._display.warning
        self._display.warning = lambda msg: (sys.stdout.write('\n'), sys.stdout.flush(), _warning(msg))

    def v2_playbook_on_task_start(self, task, is_conditional):
        pass

    def v2_playbook_on_handler_task_start(self, task):
        pass

    def v2_playbook_on_include(self, include):
        pass

    def v2_runner_on_skipped(self, result, ignore_errors=False):
        sys.stdout.write('.')
        sys.stdout.flush()

    def v2_runner_item_on_skipped(self, result):
        pass

    def v2_runner_on_ok(self, result, **kwargs):
        if not result.is_changed():
            sys.stdout.write('.')
            sys.stdout.flush()
            return
        super().v2_runner_on_ok(result, **kwargs)

    def v2_runner_item_on_ok(self, result):
        if not result.is_changed():
            sys.stdout.write('.')
            sys.stdout.flush()
            return
        super().v2_runner_item_on_ok(result)
