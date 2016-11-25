# Alarm Clock

This is a simple web application to help my wife and I get up in the morning. 

## Installing and Running

1. Clone this repository
2. `gem install bundler`
3. `bundler install`
    * If there is a gem that isn't installing, you may be missing a package or two. Consult
    the log files to figure out what those packages are and troubleshoot accordingly.
4. Modify `alarm_config.yml` according to your database adapter, schema name, username and
password
    * This repository comes with the data mapper mysql adapter. You may need to modify
    the config.ru file to require the proper adapter gem. Consult [this page](http://datamapper.org/getting-started.html)
    for help getting the proper adapter put together.
5. Test everything out by the command `rackup config.ru`
    * This command will let you know if there is an issue with your database. Check your DB,
    your config file and then run it again to ensure that it is working properly.
6. Deploy whichever way you would like.

## How can I help out?

I am not a Javascript programmer. I know just enough to get by. If you think you have
the chops to make it look/act a lot better than it does, feel free to fix it up!

If you have found a bug, please submit an issue via GitHub with very clear and precise
instructions on reproducing the bug. I'll look into it as soon as I can.

If there is an issue or something you would want to add to the application, feel
free to throw that together too. Simply follow the following procedure:

1. Fork the repo
2. Make your changes
3. Add test cases to the spec file
4. **Add test cases to the spec file**
5. Submit a pull request