# CaixaBankHomeBank [![Build Status](https://travis-ci.com/namelivia/lacaixa-homebank.svg?branch=develop)](https://travis-ci.com/namelivia/lacaixa-homebank) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/6497b23f27b648c6b266a00fb768ebe5)](https://www.codacy.com/app/ohcan2/lacaixa-homebank?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=namelivia/lacaixa-homebank&amp;utm_campaign=Badge_Grade)

<p align="center">
  <img src="https://raw.githubusercontent.com/namelivia/caixabank-homebank/readme-update/logo.png" alt="CaixabankHomebank Logo"/>
</p>

Transforms transaction .XLS files extracted from the [CaixaBank](https://www.caixabank.es/) website into .QIF files for importing them into [HomeBank](homebank.free.fr/). Also remembers categories for repeating transactions and auto-assign them.

## CaixaBank
[CaixaBank](https://www.caixabank.es/) is a Spanish bank that offers some online services for their accounts on their online platform called CaixaBankNow. In that online platform clients can among other things, query their account balances and movements through CaixaBankNow's web interface. Also there is an export feature that allows client to download transaction lists as .XLS files.

## HomeBank
[HomeBank](homebank.free.fr/) is a free software that useful for managing personal accounting.
It is designed to easy to use and be able to analyse your personal finance and budget in detail using powerful filtering tools and beautiful charts. And it has been my choice to control my personal finance for many years.

## Why
The reason to write this sofware was to allow managing account information using all the cool features HomeBank comes with, without manually copying every single transaction from the web browser into HomeBank's GUI. This software was intially written many years ago for the archaic Caja Navarra's online platform, but after [their scandal](https://en.wikipedia.org/wiki/Caja_Navarra_scandal) it had to be entirely rewritten for CaixaBank. Sadly at the time CaixaBank was [charging 3€](https://twitter.com/namelivia/status/260138045590876160) for clicking a HTML to Excel button, but they have changed that and you can freely export the information as seen in your web browser to an XLS file.
There is another reason to use this sofware, the bank was charging a penalty for those users who logged in more than 100 times a month on their online platform, if the information is stored in HomeBank you can access it as much as you like and no one will charge you anything.

## Installation
Pending 

## Usage
To execute the script ensure the file `converter` located on the project's root folder has permissions to be executed, if not, give it this permission by executing this command: `chmod +x converter` on that root folder. Then execute the converter by executing this command `./converter input.xls output.qif` on the project's root folder replacing `input.xls` with the URI of your XLS file (i.e. `/home/user/transactions.xls`) and `output.qif` with the URI of the QIF file you want to create (i.e. `/home/user/transactions.qif`) . The software will start transforming the transactions and as soon as it founds one with a non-automatically resolvable category you will be asked for adding it to an existent category, or instead, leave the category empty and fill in the memo field for uncategorized transactions. Once a category has been selected the application will remember that transaction name and the selected category will be automatically applied for all transactions named that way during that execution and later executions. Once the execution finishes you will be noticed and the program will exit and the QIF file will be ready on the location provided.

## Contributing
Pending
