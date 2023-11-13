# PostMortem

Following the rollout of ALX School's System Engineering & DevOps project 0x19, an outage transpired at approximately 12:00pm  East Standard Time (EST) within an isolated Ubuntu 14.04 container hosting an Apache web server. GET requests on the server yielded `500 Internal Server Error` responses, contrary to the expected HTML file defining a basic Holberton WordPress site.
## Troubleshooting Procedure
Bug investigator Brennan (BDB... as in my actual initials... made that up on the spot, not bad, huh?) identified the issue around 19:20 PST and promptly initiated the resolution process.

1. Examined active processes using `ps aux`. Verified the proper operation of two `apache2` processes - one under `root` and the other under `www-data`.

2. Scrutinized the `sites-available` directory within `/etc/apache2/`, confirming that the web server served content located in `/var/www/html/`.

3. Employed `strace` on the PID of the `root` Apache process in one terminal while executing a `curl` on the server in another. Unfortunately, `strace` yielded no pertinent information.

4. Replicated the process, this time focusing on the PID of the `www-data` process. Encountered an `-1 ENOENT (No such file or directory)` error while attempting to access `/var/www/html/wp-includes/class-wp-locale.phpp`.

5. Inspected files within the `/var/www/html/` directory individually, utilizing Vim pattern matching to identify the erroneous `.phpp` file extension. Located the discrepancy in the `wp-settings.php` file (Line 137, `require_once( ABSPATH . WPINC . '/class-wp-locale.php' );`).

6. Rectified the issue by removing the extraneous `p` from the line.

7. Conducted another `curl` test on the server, achieving a successful status of 200.

8. Formulated a Puppet manifest to automate the resolution process.

## Summary

In essence, a typographical error was the root cause. The WordPress application encountered a critical error in `wp-settings.php` while attempting to access the file `class-wp-locale.phpp`. The correct file name, located in the `wp-content` directory of the application folder, is `class-wp-locale.php`. The resolution involved a straightforward correction of the typo by eliminating the trailing `p`.

## Preventive Measures

This outage did not stem from a web server malfunction but rather an application error. To avert such incidents in the future, consider the following recommendations:

* Conduct thorough testing of the application before deployment to identify and address errors at an early stage.

* Implement status monitoring tools, such as [UptimeRobot](./https://uptimerobot.com/), to receive immediate alerts in the event of a website outage.

It's worth noting that in response to this incident, I authored a Puppet manifest [0-strace_is_your_friend.pp](https://github.com/Scott-TechStar/alx-system_engineering-devops/blob/master/0x17-web_stack_debugging_3/0-strace_is_your_friend.pp) to automate the resolution of identical errors in the future. The manifest substitutes any `phpp` extensions in the file `/var/www/html/wp-settings.php` with `php`. However, with the meticulous nature of programmers, rest assured such errors will be a thing of the past! 😉