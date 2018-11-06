# CaixaBankHomeBank [![Build Status](https://travis-ci.com/namelivia/caixabank-homebank.svg?branch=develop)](https://travis-ci.com/namelivia/caixabank-homebank) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/6497b23f27b648c6b266a00fb768ebe5)](https://www.codacy.com/app/ohcan2/lacaixa-homebank?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=namelivia/lacaixa-homebank&amp;utm_campaign=Badge_Grade)

<p align="center">
  <img src="https://raw.githubusercontent.com/namelivia/caixabank-homebank/develop/images/logo.png" alg="CaixaBankHomeBank logo"/>
</p>

Transforms transaction .XLS files extracted from the [CaixaBank](https://www.caixabank.es/) website into .CSV or .QIF files for importing them into [HomeBank](homebank.free.fr/). Also remembers categories for repeating transactions and automatically assigns them.

## CaixaBank
[CaixaBank](https://www.caixabank.es/) is a Spanish bank that offers some online services for their accounts on their online platform called CaixaBankNow. In that online platform clients can among other things, query their account balances and movements through CaixaBankNow's web interface. Also there is an export feature that allows clients to download transaction lists as .XLS files.

## HomeBank
[HomeBank](homebank.free.fr/) is a free software that useful for managing personal accounting.
It is designed to be easy to use and to be able to analyse your personal finance and budget in detail using powerful filtering tools and beautiful charts. It has been my choice to control my personal finance for many years.

## Why
The reason to write this sofware was to allow managing CaixaBank's accounts information using all the cool features HomeBank comes with, without manually copying every single transaction from the web browser into HomeBank's GUI. This software was intially written many years ago for the old Caja Navarra's online platform, but after [beign eaten by CaixaBank](https://en.wikipedia.org/wiki/Caja_Navarra_scandal) I rewrote it entirely for CaixaBank's online platform. Sadly at the time CaixaBank was [charging 3€](https://twitter.com/namelivia/status/260138045590876160) for clicking a Download to Excel button, but they have changed that and now you can freely export the information as seen in your web browser to an XLS file.
There is another reason to use this sofware, the bank was charging a penalty to those users who logged in more than 100 times a month on their online platform, if the information is stored in HomeBank you can access it as much as you like and no one will charge you anything.

## Requirements

[Ruby >= 2.2.0](https://www.ruby-lang.org) and [bundler](https://bundler.io)

## Installation
1. Clone the project.
2. Execute `bundler install` on the project's root folder to install all it's dependencies.

## Usage

#### Before using the application
1. To download a XLS file from CaixaBank's online platform first login using the CaixaBankNow login form on their website.

![CaixaBankNow login form](https://raw.githubusercontent.com/namelivia/caixabank-homebank/develop/images/readme1.png)

2. Once there paginate as needed to display all the transactions you want to download and then click on the *Download in Excel* button:

![Download in excel button](https://raw.githubusercontent.com/namelivia/caixabank-homebank/develop/images/readme2.png)

3. Click on the upper link for downloading the *information show on the screen*, otherwise they will take you to another form for requesting a paid service.

![Click on the upper link](https://raw.githubusercontent.com/namelivia/caixabank-homebank/develop/images/readme3.png)

And then just save the provided file on your system.

Alternatively can also take a look at [their instructions](https://www.caixabank.es/particular/bancadistancia/movimientosexcelv2_es.html) on downloading transactions in Excel (English not avaiable at the moment).

#### Using the application
To execute the script ensure the file `converter` located on the project's root folder has permissions to be executed, if not, give it this permission by executing this command: `chmod +x converter` on that root folder.

Then execute the converter by executing this command `./converter -i input.xls -o output.csv` on the project's root folder replacing `input.xls` with the URI of your XLS file (i.e. `/home/user/transactions.xls`) and `output.csv` with the URI of the CSV file you want to create (i.e. `/home/user/transactions.csv`) .

If you want to export the file to a QIF file instead of a CSV file include the `-f` parameter like this `./converter -i input.xls -o output.qif -f qif`. **Warning:** QIF files won't include the transaction name in the info field due to format limitations.

The software will start transforming the transactions and as soon as it founds one with a non-automatically resolvable category you will be asked for adding it to an existent category, or instead, leave the category empty and fill in the memo field for uncategorized transactions.

Once a category has been selected the application will remember that transaction name and the selected category will be automatically applied for all transactions named that way during that execution and later executions.
When the execution finishes you will be noticed and the program will exit and the CSV or QIF file will be ready on the location provided.

#### After using the application
To import the resulting file into HomeBank, check the [importing files section on HomeBank's documentation](http://homebank.free.fr/help/use-import.html)

## Contributing
Any suggestion, bug reports, localization translations or any other kind enhacements are welcome. Just [open an issue first](https://github.com/namelivia/caixabank-homebank/issues/new), for creating a PR remember this project has linting checkings and unit tests so any PR should comply with both before beign merged, this checks will be automatically applied when opening or modifying the PR's.
