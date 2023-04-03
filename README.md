# Tomba email finder Nmap script

Use Tomba email finder to lookup for emails on websites.

## Getting Started

- See the [official documentation](https://developer.tomba.io/).


### Requirements

- Nmap 7.60 and above
- Tomba account You can get a free key from [Tomba register](https://app.tomba.io/auth/register)

### Installation

Copy the **tomba.nse** to your Nmap program directory/scripts.

***Note***: directory

- for Linux user should be under **/usr/share/nmap**
- for Windows user should be under **C:\Program Files (x86)\Nmap**

### How to Use

with args:

```bash
nmap --script tomba <target> --script-args 'tomba.key=ta_xxxx,tomba.secret=ts_xxxx'
````

or Set your Tomba API key and secret on the **file tomba.nse** to avoid typing it in every time

```bash
nmap --script tomba <target>
```

### How to Use

![Response](response.svg)

### Parameters

- **key**      Tomba api key.
- **secret**   Tomba api secret.

### About Tomba

Founded in 2021, Tomba prides itself on being the most reliable, accurate, and in-depth source of Email address data available anywhere. We process terabytes of data to produce our Email finder API, company.

[![image](https://avatars.githubusercontent.com/u/67979591?s=200&v=4)](https://tomba.io/)

## License

Please see the [Apache 2.0 license](http://www.apache.org/licenses/LICENSE-2.0.html) file for more information.
