#!/usr/bin/python

ANSIBLE_METADATA = {
    'metadata_version': '1.0',
    'status': ['preview'],
    'supported_by': 'community'
}

# Shamelessly copied / adapted from:
#    https://github.com/mcsrainbow/ansible-playbooks-bind9/blob/master/library/heylinux/myfacts

from ansible.module_utils.basic import AnsibleModule
import commands

def main():
    module = AnsibleModule(
        argument_spec = dict(
            domain_names=dict(type='str', required=True),
        ),
        supports_check_mode = True,
    )

    result = dict(
        changed=False,
        dns_newser={}
    )

    if module.check_mode:
        return result

    if module.params['domain_names']:
        domain_names_list = module.params['domain_names'].split(",")
        for domain_name in domain_names_list:
            serial_number = commands.getoutput("""dig soa %s |grep -A1 'ANSWER SECTION' |tail -n 1 |awk '{print $7}'""" % (domain_name))
            dns_newser = int(serial_number) + 1            
            result['dns_newser'][domain_name] = dns_newser
            result['changed'] = True


    module.exit_json(**result)

if __name__ == '__main__':
    main()
