Introduction

PhantomJS is a scripted, headless browser that can be used for automating web page interaction. PhantomJS is a free, open source and distributed under the BSD license. PhantomJS is based on WebKit and is very similar browsing environment to Safari and Google Chrome. The PhantomJS JavaScript API can be used to open web pages, execute user actions and take screenshots.

Step 1: Update the system

Before starting, it is recommended to update the system with the latest stable release. You can do this with the following command:

sudo apt-get update -y
sudo apt-get upgrade -y
sudo shutdown -r now

Step 2: Install PhantomJS

Before installing PhantomJS, you will need to install some required packages on your system. You can install all of them with the following command:

sudo apt-get install build-essential chrpath libssl-dev libxft-dev libfreetype6-dev libfreetype6 libfontconfig1-dev libfontconfig1 -y

# dpkg -l|grep build-essential

# sudo apt-get install chrpath

Next, you will need to download the PhantomJS. You can download the latest stable version of the PhantomJS from their official website. Run the following command to download PhantomJS:

# sudo wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-i686.tar.bz2

Once the download is complete, extract the downloaded archive file to desired system location:

# sudo tar xvjf phantomjs-2.1.1-linux-i686.tar.bz2 -C /usr/local/share/

# cd /usr/local/share/phantomjs-2.1.1-linux-i686/bin/ & sudo chmod +x phantomjs

Next, create a symlink of PhantomJS binary file to systems bin dirctory:

# sudo ln -s /usr/local/share/phantomjs-2.1.1-linux-i686/bin/phantomjs /usr/local/bin/

Step 3: Verify PhantomJS

PhantomJS is now installed on your system. You can now verify the installed version of PhantomJS with the following command:

# phantomjs --version

You should see the following output:

2.1.1

You can also find the version of the PhantomJS from PhantomJS prompt as shown below:

# phantomjs

You will get the phantomjs prompt:

phantomjs>

Now, run the following command to find the version details:

# phantomjs> phantom.version

You should see the following output:

{
   "major": 2,
   "minor": 1,
   "patch": 1
}
# ------------------------------------------------------
Pip is a package management system that simplifies installation and management of software packages written in Python such as those found in the Python Package Index (PyPI). Pip is not installed by default on Ubuntu 18.04, but the installation is pretty straightforward.

In this tutorial, we will show you how to install Python Pip on Ubuntu 18.04 and go through the basics of how to install and manage Python packages with pip.

Install Pip

There are several different ways to install pip on Ubuntu 18.04, depending on your preferences and needs. In this guide, we will install pip for both Python2 pip and Python3 pip3 using the apt package manager.

Before installing any package with apt it is recommended to update the package list with:
sudo apt update

Install pip for Python 2

The following command will install pip for Python 2 and all of it’s dependencies:
sudo apt install python-pip

Once the installation is complete, we can verify the installation with the following command which will print the pip version:

# pip --version
pip 9.0.1 from /usr/lib/python2.7/dist-packages (python 2.7)


Install pip for Python 3

To install pip3 for Python 3.x run:
sudo apt install python3-pip

Same as before we will verify the pip3 installation with:
# pip3 --version
pip 9.0.1 from /usr/lib/python3/dist-packages (python 3.6)

# python2 -m pip --version
pip 1.5.4 from /usr/lib/python2.7/dist-packages (python 2.7)
# python3 -m pip --version 
pip 18.0 from /usr/local/lib/python3.4/dist-packages/pip (python 3.4)

# pip3 --version
pip 18.0 from /usr/local/lib/python3.4/dist-packages/pip (python 3.4)
# pip2 --version
pip 1.5.4 from /usr/lib/python2.7/dist-packages (python 2.7)

I usually just run the following commands to upgrade both pip2 (=pip by default) and pip3:
# sudo -H pip3 install --upgrade pip
# sudo -H pip2 install --upgrade pip

----------------------------------------------------------------
wget //link goes here
tar -xzvf pip-9.0.1.tar.gz
cd pip-9.0.1
sudo python3 setup.py install

the version should be changed to the latest version and the link can be updated with the latest version's link
----------------------------------------------------------------


# pip2 --version
pip 18.0 from /usr/local/lib/python2.7/dist-packages/pip (python 2.7)
# pip3 --version
pip 18.0 from /usr/local/lib/python3.4/dist-packages/pip (python 3.4)


pip install scrapy
scrapy is Python library for crawling web sites and extracting structured data

To uninstall a package run:
pip uninstall scrapy

To search packages from PyPI:
pip search "search_query"

To list installed packages:
pip list

To list outdated packages:
pip list --outdated

# sudo pip2 install selenium

# TypeError: urlopen() got multiple values for keyword argument 'body'
# Upgrading urllib3 to the latest version (atleast v1.10) will solve your problem.
# sudo -H pip2 uninstall urllib3
# sudo -H pip2 install --upgrade urllib3
# pip2 search "urllib3"
# sudo -H pip2 uninstall 'urllib3>1.6.0,<1.8.0'
# sudo -H pip2 install urllib3

from selenium import webdriver
driver = webdriver.PhantomJS()
driver.get('https://www.baidu.com')
news = driver.find_element_by_xpath("//div[@id='u1']/a")
print news.text
driver.quit() 
# 记得关闭，不然耗费内存


You can pass commandline arguments to the PhantomJS instance behind the scenes by passing them as a list to the service_args argument:
webdriver.PhantomJS(service_args=['--cookies-file=/tmp/ph_cook.txt'])

driver = webdriver.PhantomJS(executable_path=r'phantomjs')

The Release Notes of Selenium v3.6.0 clearly mentions Add options to start Firefox and Chrome in headless modes. So we need to use the Options Class as follows to invoke the headless argument:

from selenium import webdriver
from selenium.webdriver.firefox.options import Options
options = Options()
options.add_argument("--headless")
options.add_argument('--no-sandbox')
driver = webdriver.Firefox(firefox_options=options, executable_path=r'phantomjs')
print("Firefox Headless Browser Invoked")
driver.get('https://www.baidu.com/')
driver.quit()


Now, let’s install xvfb so we can run Chrome headlessly:
sudo apt-get install xvfb

wget -N http://chromedriver.storage.googleapis.com/2.26/chromedriver_linux32.zip

wget -N http://chromedriver.storage.googleapis.com/2.0/chromedriver_linux32.zip

wget -N http://chromedriver.storage.googleapis.com/2.2/chromedriver_linux32.zip

unzip chromedriver_linux32.zip
chmod +x chromedriver

sudo mv -f chromedriver /usr/local/share/chromedriver
sudo ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver
sudo ln -s /usr/local/share/chromedriver /usr/bin/chromedriver

import os
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

options = webdriver.ChromeOptions()
options.add_experimental_option("excludeSwitches",["ignore-certificate-errors"])
options.add_argument('--disable-gpu')
options.add_argument('--headless')
options.add_argument('--no-sandbox')

chromedriver = "/usr/bin/chromedriver"
os.environ["webdriver.chrome.driver"] = chromedriver
browser = webdriver.Chrome(chrome_options=options,executable_path='chromedriver')
browser.get('https://www.baidu.com')


selenium chrome options

Cannot uninstall 'urllib3'. It is a distutils installed project
Try removing package 'urllib3' manually from "site-packages". This works perfect!

Uninstalling urllib3-1.23:
  Would remove:
    /usr/local/lib/python2.7/dist-packages/urllib3-1.23.dist-info/*
    /usr/local/lib/python2.7/dist-packages/urllib3/*


#ubuntu chromedriver unable to discover open pages
In my case, adding the --no-sandbox argument to ChromeOptions solved the problem.


步骤一：sudo apt-get install xvfb
步骤二：sudo xvfb-run wkhtmltopdf
   
xvfb 是通过提供一个类似 X server 守护进程 和 设置程序运行的环境变量 DISPLAY 来提供程序运行的环境，wkhtmltopdf，把HTML页面内存转换成PDF












