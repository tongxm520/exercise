#!/usr/bin/python
# -*-encoding: utf-8 -*-

import re
import time
from selenium import webdriver

def get_categories():
  driver = webdriver.PhantomJS()
  driver.set_window_size(1920, 1080)
  driver.get('http://www.yhd.com')
  ul=driver.find_elements_by_css_selector('#allsort>li')
  for li in ul:
    index = li.get_attribute('index')
    el=driver.execute_script("return $(\"li[index='"+index+"']\").trigger('mouseenter')")
    tag=len(driver.find_elements_by_css_selector("li[index='"+index+"']>.hd_show_sort>.hd_good_category"))
    while True:
      time.sleep(0.1)
      tag=len(driver.find_elements_by_css_selector("li[index='"+index+"']>.hd_show_sort>.hd_good_category"))
      if(tag!=0):
        break
    print el[0].get_attribute('outerHTML')
    print index + "---------------------------------------------------------"

  html = driver.find_element_by_tag_name('html').get_attribute('innerHTML')
  html=re.sub(r'&lt;','<',html)
  html=re.sub(r'&gt;','>',html)
  
  f = open('yhd_js_py.html','w') 
  f.write(unicode(html).encode('UTF-8'))

  driver.quit() 

if __name__ == '__main__':
  get_categories()

#html = driver.find_element_by_tag_name('html').get_attribute('innerHTML')
#html=re.sub(r'&lt;','<',html)
#html=re.sub(r'&gt;','>',html)


#html = driver.execute_script("return document.getElementsByTagName('html')[0].innerHTML")
#driver.find_elements_by_css_selector('#tab1')
#$('#some_element').trigger('hover');
#document.querySelectorAll('[data-foo="value"]');
#$("li[index='1']").trigger('mouseenter');
#string = driver.execute_script("document.querySelectorAll('[index=\""+str(1)+"\"]')")
#print driver.find_elements_by_css_selector("li[index='1']")[0].get_attribute('outerHTML')

#To do a hover you need to use the move_to_element method.
#from selenium import webdriver
#from selenium.webdriver.common.action_chains import ActionChains
#driver = webdriver.PhantomJS()
#driver.get('http://www.yhd.com')
#element_to_mouse_over = driver.find_element_by_id("baz")
#hover = ActionChains(driver).move_to_element(element_to_mouse_over)
#hover.perform()



