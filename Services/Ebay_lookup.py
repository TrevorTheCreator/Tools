import requests
from bs4 import BeautifulSoup
from selenium.webdriver.common.by import By
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.proxy import Proxy, ProxyType
from selenium.webdriver.chrome.options import Options as ChromeOptions
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.support.ui import WebDriverWait

url = "https://www.ebay.com"

#  this is our requests proxy setup
proxies = {
    'http': 'http://100.42.69.66:1994'
}


#  this is our Selenium proxy setup
PROXY = "100.42.69.66:1994"

options = ChromeOptions()
options.add_argument('--user-agent=Mozilla/5.0 (X11; CrOS x86_64 14092.77.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.107 Safari/537.36')
options.add_argument('--headless')
options.add_argument('--no-sandbox')
options.add_argument('--proxy-server={}'.format(PROXY))
driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)

driver.get(url)
WebDriverWait(driver, 5)

search_bar = driver.find_element(By.ID, "gh-ac")
search_bar.send_keys("kenwood ts-60")
search_bar_click = driver.find_element(By.ID, "gh-btn")
search_bar_click.click()

get_results = driver.find_elements(By.CLASS_NAME, "s-item__title")
get_price = driver.find_elements(By.CLASS_NAME, "s-item__price")

results_page = driver.current_url
#  need to add proxy to requests, or we'll leak our VPN IP
page = requests.get(results_page, proxies=proxies)

soup = BeautifulSoup(page.content, "html.parser")

listings = soup.find_all("li", attrs={'class': 's-item'})

for listing in listings:
    title_element = listing.find("div", class_="s-item__title")
    price_element = listing.find("span", class_="s-item__price")
    link_element = listing.find("a", {"class": "s-item__link"})["href"]
    print(title_element.text)
    print(price_element.text)
    print("Link : {}\n".format(link_element))

driver.quit()
