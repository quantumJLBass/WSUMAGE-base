# set up data first
###########################################################
{%- set project = pillar.get('project') %}
{%- set magento = pillar.get('magento') %}
{%- set magento_version = magento['version'] %} 
{%- set magento_extensions = pillar.get('extensions',{}) %}
{%- set web_root = "/var/www/" + project['target'] + "/html/" %} 
{%- set stage_root = "salt://stage/vagrant/" %}



remove-PaypalUk:
  cmd.run:
    - name: rm -app/code/core/Mage/PaypalUk/*
    - user: root
    - cwd: {{ web_root }}



#rm -rf 
#rm -rf app/code/core/Mage/Authorizenet/* app/etc/modules/Mage_Authorizenet.xml
#rm -rf app/code/core/community/Phoenix/* app/etc/modules/Phoenix_Moneybookers.xml
        
#come back on this one.. unsure   
#rm -rf app/code/core/Mage/Paypal/* app/code/core/Mage/Paypal/*
#rm -rf app/design/adminhtml/default/default/template/paypal/*




#this is how to get somethign from the connect download
#./mage download community Motech_DefaultAttributeSet



# Start the extension intsalls
{% for ext_key, ext_val in magento_extensions.iteritems() %}
base-ext-{{ ext_key }}:
  cmd.run:
    - name: modgit add {% if ext_val['tag'] is defined and ext_val['tag'] is not none %} -t {{ ext_val['tag'] }} {%- endif %} {% if ext_val['branch'] is defined and ext_val['branch'] is not none %} -b {{ ext_val['branch'] }} {%- endif %} {{ ext_key }} https://github.com/{{ ext_val['repo_owner'] }}/{{ ext_val['name'] }}.git
    - cwd: {{ web_root }}
    - user: root
    - unless: modgit ls 2>&1 | grep -qi "{{ ext_key }}"
    - require:
      - git: magento
      - service: mysqld-{{ env }}
      - service: php-{{ env }}
      - cmd: magneto-install
      - cmd: init_modgit
      
install-base-ext-{{ ext_key }}:
  cmd.run:
    - name: rm -rf {{ web_root }}var/cache/* | php "{{ web_root }}index.php" 2>/dev/null
    - cwd: {{ web_root }}
    - user: root
    - onlyif: modgit ls 2>&1 | grep -qi "{{ ext_key }}"
    - require:
      - git: magento
      - service: mysqld-{{ env }}
      - service: php-{{ env }}
      - cmd: magneto-install
      - cmd: base-ext-{{ ext_key }}
{% endfor %}