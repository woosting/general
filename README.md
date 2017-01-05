# General

Scripts and braindumps that are not worthy of their own repo.

### Set dnsmasq's server port

1. Log in to LuCi
2. Navigate to: `Network > DHCP and DNS > Advanced Settings` (tab/hyper-link) 
3. Scroll down to: `DNS Server Port`
4. Fill it (DNS Server Port) out to be: `5353`

### Set (update persistent) kresd policy

1. Execute: `echo "policy.add(policy.suffix(policy.FORWARD('127.0.0.1@5353'),  policy.todnames({'lan'})))" >> /etc/kresd.custom.conf` (persisting reboots and updates, as it is custom).

2. Execute: `cp /etc/config/resolver /etc/config/resolver.bak && vim /etc/config/resolver` and replace line 22:

 	``` 
	#option include_config '/tmp/kresd.custom.conf'
	```
	...with:

	```
	option include_config '/etc/kresd.custom.conf'
	```

	Note the removal of the hash-tag!

3. Execute: `cp /etc/init.d/kresd /etc/init.d/kresd.bak && vim /etc/init.d/kresd` and move the lines (134 & 135):

    ```
	# include custom kresd config
	include_custom_config
    ```

    ...right above (line 122 & 123):

	```
	config_get_bool do_forward "$section" forward_upstream 1
	if [ "$do_forward" = "1" ] ; then
	```

	... resulting in:

	```
	# include custom kresd config
	include_custom_config
	config_get_bool do_forward "$section" forward_upstream 1
	
	if [ "$do_forward" = "1" ] ; then
	```

4. Execute: `/etc/init.d/kresd restart && /etc/init.d/dnsmasq restart`

Also see: https://forum.turris.cz/t/dnsmasq-lan-domain-while-still-using-knot-resolver/1253/29
