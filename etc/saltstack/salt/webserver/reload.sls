# vim: sts=2 ts=2 sw=2 et ai

# reload nginx
nginx_reload:
  cmd.run:
    - name : service nginx reload
