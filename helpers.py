def fill_input(driver, selector, value):
	driver.execute_script('document.querySelector("%s").value = "%s"' % (selector, value))


def click_button(driver, selector):
	driver.execute_script('document.querySelector("%s").click()' % (selector))
