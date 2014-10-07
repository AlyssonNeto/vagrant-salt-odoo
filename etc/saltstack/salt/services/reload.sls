# vim: sts=2 ts=2 sw=2 et ai

# reread supervisor
supervisorctl-reread:
  cmd.run:
    - name : supervisorctl reread

# reload supervisor
supervisorctl-reload:
  cmd.run:
    - name : supervisorctl reload
