# nginx
#
# Meta-state to fully install nginx.

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ '/map.jinja' import nginx with context %}

include:
  {%- if nginx.ng is defined %}
  - {{ tplroot }}.deprecated
  {%- endif %}
  - {{ tplroot }}.config
  - {{ tplroot }}.service
  {%- if nginx.snippets is defined %}
  - {{ tplroot }}.snippets
  {%- endif %}
  - {{ tplroot }}.servers
  - {{ tplroot }}.certificates

extend:
  nginx_service:
    service:
      - listen:
        - file: nginx_config
      - require:
        - file: nginx_config
  nginx_config:
    file:
      - require:
        {%- if nginx.install_from_source %}
        - cmd: nginx_install
        {%- else %}
        - pkg: nginx_install
        {%- endif %}
