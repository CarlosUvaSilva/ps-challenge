import 'dotenv/config'
import puppeteer from 'puppeteer';

const selectors = {
  loginPage: 'https://app.pandascore.co/login',
  emailInput: 'input[type="email"]',
  passwordInput: 'input[type="password"]',
  loginButton: 'input[type="submit"]',
  revokeButton: 'button.btn-revoke',
  formControlInput: 'input.form-control',
};

const login = async () => {
  try {
    // Retrieve email and password from environment variables
    const email = process.env.PANDASCORE_EMAIL;
    const password = process.env.PANDASCORE_PASSWORD;

    if (!email || !password) {
      console.error('Email or password not set in environment variables.');
      return;
    }

    // Launch the browser
    const browser = await puppeteer.launch({ headless: "new" });

    // Open a new page
    const page = await browser.newPage();

    // Navigate to the login page
    await page.goto(selectors.loginPage);

    // Enter username and password
    await page.type(selectors.emailInput, email);
    await page.type(selectors.passwordInput, password);

    // Click the login button
    await Promise.all([
      page.click(selectors.loginButton),
      page.waitForNavigation(),
    ]);

    // Wait for the revoke button to appear
    await page.waitForSelector(selectors.revokeButton);

    // Configure xhr interceptor of the refresh token request
    let xhrCatcher = page.waitForResponse(
      (r) =>
        r.request().url().includes('access_token') &&
        r.request().method() === 'PUT'
    );

    // Click the revoke button
    await Promise.all([
      page.click(selectors.revokeButton),
      xhrCatcher,
    ]);

    // Get the value from the input field with class "form-control"
    const fieldHandle = await page.$(selectors.formControlInput);
    const fieldValue = await page.evaluate((element) => element.value, fieldHandle);
    console.log('Value from input field:', fieldValue);

    // Close the browser
    await browser.close();
  } catch (error) {
    console.error('An error occurred:', error);
  }
};

login();
