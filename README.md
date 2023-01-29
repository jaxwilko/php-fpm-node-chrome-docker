# PHP-FPM Node Chrome Docker

This repo contains the build scripts for a docker image containing php, node and google chrome.

### Notes

- Chrome driver is installed as `/usr/local/bin/chromedriver`
- When running chrome, use the following flags:
    ```bash
    --headless --no-sandbox
    ```
