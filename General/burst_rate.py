import random
import time
import os.path
import argparse
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options as ChromeOptions
from webdriver_manager.chrome import ChromeDriverManager


#  get arguments from cmd line
parser = argparse.ArgumentParser(description="Take photos of sites and see if they are resolving or not")
parser.add_argument("-L", dest="wordlist", help="[+] Specify a list of domains to snapshot")
parser.add_argument("-O", dest="mobile", help="[+] Use mobile user-agent")
args = parser.parse_args()
if not args.wordlist:
    parser.error("[-] use the -L flag to specify a wordlist of domain names")


#  check if the wordlist provided exists or not
def check_exist_wordlist(word_list_input, o="mobile"):
    #  assume the wordlist is in the same directory as this script
    path = "./" + args.wordlist
    if args.mobile:
        mobile_agent(args.wordlist)
    elif os.path.isfile(path):
        photo_op(args.wordlist)
    else:
        print("Cannot find specified file. Please verify that it exists.")


def mobile_agent(word_list_input):
    try:
        with open(args.wordlist) as f:
            lines = f.readlines()
        options = ChromeOptions()
        options.add_argument('--user-agent=Mozilla/5.0 (iPhone; CPU iPhone OS 16_1_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Mobile/15E148 Safari/604.1')
        options.add_argument('--headless')
        options.add_argument('--no-sandbox')
        #  this will optionally set the window size, incase you are pretending to be a mobile phone
        options.add_argument('--window-size=375,812')
        driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)
        for line in lines:
            try:
                driver.get("https://" + line)
                WebDriverWait(driver, 10)
            #  broad exception due to verbose cmd line
            except Exception:
                continue

            #  we only want to write to the .txt file if we get a picture of the domain
            driver.save_screenshot(picture_path + "{0}.png".format(line))
            with open(out_file, 'a+') as file_object:
                file_object.write(line)
            time.sleep(3)

        driver.quit()

    except Exception as e:
        print(e)


#  take wordlist from command line as argument to function
def photo_op(word_list_input):
    try:
        with open(args.wordlist) as f:
            lines = f.readlines()
        options = ChromeOptions()
        options.add_argument('--user-agent={}'.format(ua_random))
        options.add_argument('--headless')
        options.add_argument('--no-sandbox')
        driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)
        for line in lines:
            try:
                driver.get("https://" + line)
                WebDriverWait(driver, 10)
            #  broad exception due to verbose cmd line
            except Exception:
                continue

            #  we only want to write to the .txt file if we get a picture of the domain
            driver.save_screenshot(picture_path + "{0}.png".format(line))
            with open(out_file, 'a+') as file_object:
                file_object.write(line)
            time.sleep(3)

        driver.quit()

    except Exception as e:
        print(e)


#  this is the file location of the domains that appear to be up
picture_path = os.path.expanduser("~/Pictures/")
file_path = os.path.expanduser("~/Desktop/")
out_file = file_path + "/domains.txt"

#  create list of UA strings to use
#  add your own, or comment others out to be specific
ua_options = [
    "Mozilla/5.0 (iPhone; CPU iPhone OS 16_1_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Mobile/15E148 Safari/604.1",
    "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)",
    "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36",
    "Mozilla/5.0 (X11; CrOS x86_64 14092.77.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.107 Safari/537.36",
    "WeatherReport/1.2.2 CFNetwork/485.12.7 Darwin/10.4.0",
    "Mozilla/5.0 (iPad; CPU OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148",
    "Mozilla/5.0 (Linux; Android 7.1.2; AFTMM Build/NS6265; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/70.0.3538.110 Mobile Safari/537.36",
    "Mozilla/5.0 (Android 9; Mobile; rv:68.0) Gecko/68.0 Firefox/68.0",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36",
    "BrightSign/8.3.23 (XT1144) Mozilla/5.0 (X11; Linux aarch64) AppleWebKit/537.36 (KHTML, like Gecko) QtWebEngine/5.12.3 Chrome/69.0.3497.128 Safari/537.36",
    "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9a1) Gecko/20070308 Minefield/3.0a1",
    "Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101 Thunderbird/45.8.0",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36"
]

#  randomly choose a UA string for use in the photo_op() function
ua_random = random.choice(ua_options)

#  we start by checking if the wordlist exists
#  the primary function photo_op is only called if the wordlist exists
check_exist_wordlist(args.wordlist, o="mobile")
