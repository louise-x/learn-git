import requests
import os
import json
import logging
import sys
import ipaddress

# log_level = {
#                 "CRITICAL": logging.CRITICAL,
#                 "ERROR" : logging.ERROR,
#                 "WARNING" : logging.WARNING,
#                 "INFO" : logging.INFO,
#                 "DEBUG" : logging.DEBUG
#             }
# log = logging.getLogger(__name__)
# log.setLevel(log_level[os.environ.get('LOG_LEVEL',"DEBUG")])


log = logging.getLogger(__name__)
log.setLevel(logging.DEBUG)

handler = logging.StreamHandler(sys.stdout)
handler.setLevel(logging.DEBUG)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
log.addHandler(handler)

def parse_gh_actions_ipset(
        gh_api_url: str = 'https://api.github.com/meta'
    ) -> (list, list):
    """
    Query GitHub API to get the most recent git actions ip range.
        Parameters:
            gh_api_url (str): github official api metadata endpoint 
        Returns:
            actions ipv4 and ipv6 tuple list (tuple(list, list))
    """
    response = requests.get(gh_api_url)
    response.raise_for_status()
    actions_ips = response.json().get('actions')
    
    return (
      [ip for ip in ( actions_ips or [] ) if ':' not in ip and filter_invalid_ip(ip)], 
      [ip for ip in ( actions_ips or [] ) if ':' in ip and filter_invalid_ip(ip)]
    )
    
def filter_invalid_ip(ip_addr: str) -> str:
  try:
    ipaddress.ip_network(ip_addr)
    return ip_addr
  except ValueError:
    pass

def dump_gh_actions_ipset (
  ipset: list = [],
  target_filepath: str = "./gh_actions_ip/gh_actions_ipset.txt"
) -> dict:
  # load file
  # compare if diff
  prev = set(line.strip() for line in open(target_filepath))
  current = set(ipset)
  log.info(f"previous ip set lenght: {len(prev)}")
  # log.info(f"intersection from previous: {len(prev & current)}")
  if (len(prev & current) == len(prev) - 2):
    log.info(f"there is no change, return early")
    return

  vpn_list = os.environ["VPN"].replace(' ', '').split(',')
  log.info(f"vpn_list : {vpn_list}")
  ipset.extend(vpn_list)
  log.info(f"ipset ip set lenght: {len(ipset)}")
  with open(target_filepath, 'w') as f:
    for line in ipset:
        f.write(f"{line}\n")

if __name__ == '__main__':
  ipset = parse_gh_actions_ipset()
  # ipset[0] is ipv4
  dump_gh_actions_ipset(ipset[0])