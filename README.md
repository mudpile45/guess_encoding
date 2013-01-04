#Description
This is a simple script that uses heuristics and Chinese frequency data distributions to guess the text encoding and script (Simplified or Traditional) of any piece of Chinese text.

It's been accurate on everything I've thrown at it so far, but 
## Usage
    
    $ perl guess_encoding.pl whatami.txt
      big5 / trad      
    $ iconv -f big5 -t utf-16 whatami.txt > utf16.txt
    $ perl guess_encoding.pl utf16.txt
      utf-16 / trad          
    
## Supported Encodings
Most any encoding that you might find Chinese text in the wild saved in is supported.

* UTF-8 
* EUC-CN (also known as GB2312)
* BIG5
* UTF-16 (LE or BE)

## How it works
Hashes of the most frequent Chinese characters are stored inside the file, so the system tries the text in each encoding and checks which one has the highest count of these frequent characters. Simple, but effective. 

### Frequency lists
If for some reason you need to replace the frequency list that's inside the file, just create a UTF8 encoded file with one character per line in order of highest frequency to lowest.

Then use use the `get_freq_data_from_file()` function and the `merge_freq_data()` (if you want to merge traditional and simplified sets), dump the hash to a file with `Data::Dumper` and replace the hashes returned by `get_freq_data()` 
                                                                  

