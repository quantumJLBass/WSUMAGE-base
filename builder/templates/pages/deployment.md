{% markdown %}
# WSU Magento deployment guide

## WSU Magento Installation
There is a simple bash script, `gitploy`, that is used for the install and updating of the files needs for a Magento app.  `gitploy` is used to manage the install of the app.  This script will take a git repository and clone it to the server.  To advoid issues and the need for over use of submodules, gitploy tracks the local repository in a sub folder and sets things up do that you never have to worry about the install becoming corrupted.  For more information on how gitploy works please referr to the documantion.  The comand that is nomarly run in get the up today Magento app is something like,

    `$>_ gitploy -t lastest MAGE http://github.com/washingtonstateuniversity/magento-mirror.git`
What that command wil do is to clone in the repo for the latest tag of Magento.  Wsu hosts a mirror of all versions of Magento release starting from 1.8.0.0.  The `-t latest` option will chose the last tagged release.

## WSU Magento Updates/Restores
The gitploy is used to update the install with a simple command.  `gitploy up -t latest MAGE`  That is all it will take to run the update.  If you are trying to do this update one a WSU server you must be ssh'd in as a sudo user.  See the server notes for more information. 

Sometimes there could be some misstake where in the files have been corrupted or removed.  In this case you can refrest the managed files with this command, `gitploy re MAGE`.  Since you are not moving from one tag/commit to another, there is no need to use the option flags.  This wil rebuild the deployment list and restore the files that are missing and overwirte the files that are not.  This can be used in noval ways besides the case where you know there were files deleted or something.  One usage of the gitploy refresh could be to set a cron job that runs the command to refresh every night at lets say 2am.  If the system have been infected with malwear then the file affected would be wiped.  This porcess wouldn't remove files that were added to the system, but in the sense that the compromissed Magento app files would have been used to server the stray infected files, you have prevented users from accessing the infected files.  A checksome is always a wise idea to insure the the system is safe, as wel as normal malwear and anti virus scans.

## Deployment Notes
It is highly suggested that you do not run the gitploy out side of the Salt provisionor unless it is to refresh the installation.  The provisioning is used to install and update as needed.  Since access is restricted it will not be something that any user may run the `gitploy` script.

**Note:** More to come. Thank you for reading.
	
{% endmarkdown %}