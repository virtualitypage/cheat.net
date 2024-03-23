#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
sub_file=$current_dir/output.csv

function build_HTML_ShellCode () {
  span1="<span class=\"string\">$col1</span>"
  span2="<span class=\"string\">$col2</span>"
  span3="<span class=\"string\">$col3</span>"
  span4="<span class=\"string\">$col4</span>"
  span5="<span class=\"string\">$col5</span>"
  span6="<span class=\"string\">$col6</span>"
  span7="<span class=\"string\">$col7</span>"
  span8="<span class=\"string\">$col8</span>"
  span9="<span class=\"string\">$col9</span>"
  span10="<span class=\"string\">$col10</span>"
  span11="<span class=\"string\">$col11</span>"
  span12="<span class=\"string\">$col12</span>"
  span13="<span class=\"string\">$col13</span>"
  span14="<span class=\"string\">$col14</span>"
  span15="<span class=\"string\">$col15</span>"
  span16="<span class=\"string\">$col16</span>"
  span17="<span class=\"string\">$col17</span>"
  span18="<span class=\"string\">$col18</span>"
  span19="<span class=\"string\">$col19</span>"
  span20="<span class=\"string\">$col20</span>"

  while IFS=' ' read -r col1 col2 col3 col4 col5 col6 col7 col8 col9 col10 col11 col12 col13 col14 col15 col16 col17 col18 col19 col20 || [[ -n $col20 ]]; do
    echo "$col1,$col2,$col3,$col4,$col5,$col6,$col7,$col8,$col9,$col10,$col11,$col12,$col13,$col14,$col15,$col16,$col17,$col18,$col19,$col20" >> "$sub_file"
  done < "$current_dir/$main_file"

  cat << EOF >> "$current_dir/$main_file.html"
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width">
    <title>$main_file</title>
  </head>
  <body class="static">
    <div id="output">
      <div id="css-box" class="active">
        <code data-lang="css" id="actual-css-code" class="cm-s-default">
          <pre>
            <code>
EOF

  while IFS=, read -r col1 col2 col3 col4 col5 col6 col7 col8 col9 col10 col11 col12 col13 col14 col15 col16 col17 col18 col19 col20 || [[ -n $col20 ]]; do
    if [ "$col1" = "\"" ] || [ "$col1" = "\"/\"" ] || [ "$col1" = "\")" ] || [ "$col1" = "/\"" ] || [ "$col1" = "/" ]; then
      span1="<span class=\"string\">$col1</span>"
    elif [[ "$col1" =~ "#" ]]; then
      span1="<span class=\"memo\">$col1</span>"
    elif [ "$col1" = "function" ]; then
      span1="<span class=\"option\">$col1</span>"
    elif [ "$col1" = "}" ]; then
      span1="<span class=\"yellow\">$col1</span>"
    elif [ "$col1" = "if" ] || [ "$col1" = "elif" ] || [ "$col1" = "else" ] || [ "$col1" = "fi" ] || [ "$col1" = "for" ] || [ "$col1" = "while" ] || [ "$col1" = "done" ] || [ "$col1" = "continue" ] || [ "$col1" = "break" ] || [ "$col1" = "return" ]; then
      span1="<span class=\"purple\">$col1</span>"
    elif [ "$col1" = "echo" ] || [ "$col1" = "cat" ] || [ "$col1" = "mkdir" ] || [ "$col1" = "rmdir" ] || [ "$col1" = "sleep" ] || [ "$col1" = "cd" ] || [ "$col1" = "rm" ] || [ "$col1" = "df" ] || [ "$col1" = "exit" ] || [ "$col1" = "printf" ] || [ "$col1" = "printf" ] || [ "$col1" = "printf" ] || [ "$col1" = "read" ] || [ "$col1" = "rsync" ] || [ "$col1" = "zip" ]; then
      span1="<span class=\"command\">$col1</span>"
    elif [ "$col1" = "then" ] || [ "$col1" = "do" ]; then
      span1="<span class=\"purple\">$col1</span>"
    elif [[ "$col1" =~ "$" ]]; then
      span1="<span class=\"value\">$col1</span>"
    elif [[ "$col1" =~ "-" ]] || [[ "$col1" =~ "--" ]]; then
      span1="<span class=\"option\">$col1</span>"
    elif [ "$col1" = ">>" ] || [ "$col1" = "2>" ] || [ "$col1" = "=" ] || [ "$col1" = ";" ]; then
      span1="<span class=\"white\">$col1</span>"
    elif [[ "$col1" = *"\\\""* ]]; then
      span1="<span class=\"back_slash\">$col1</span>"
    elif [[ "$col1" = "" ]]; then
      span1=""
    else
      span1="<span class=\"string\">$col1</span>"
    fi

    if [ "$col2" = "\"" ] || [ "$col2" = "\"/\"" ] || [ "$col2" = "\")" ] || [ "$col2" = "/\"" ] || [ "$col2" = "/" ]; then
      span2="<span class=\"string\">$col2</span>"
    elif [[ "$col2" =~ "#" ]]; then
      span2="<span class=\"memo\">$col2</span>"
    elif [[ "$col2" =~ "$" ]]; then
      span2="<span class=\"value\">$col2</span>"
    elif [ "$col2" = "then" ] || [ "$col2" = "do" ]; then
      span2="<span class=\"purple\">$col2</span>"
    elif [[ "$col2" =~ "-" ]] || [[ "$col2" =~ "--" ]]; then
      span2="<span class=\"option\">$col2</span>"
    elif [ "$col2" = "[" ]; then
      span2="<span class=\"yellow\">$col2</span>"
    elif [ "$col2" = ">>" ] || [ "$col2" = "2>" ] || [ "$col2" = "=" ] || [ "$col2" = ";" ]; then
      span2="<span class=\"white\">$col2</span>"
    elif [[ "$col2" = *"\\\""* ]]; then
      span2="<span class=\"back_slash\">$col2</span>"
    elif [[ "$col2" = "" ]]; then
      span2=""
    else
      span2="<span class=\"string\">$col2</span>"
    fi

    if [ "$col3" = "\"" ] || [ "$col3" = "\"/\"" ] || [ "$col3" = "\")" ] || [ "$col3" = "/\"" ] || [ "$col3" = "/" ]; then
      span3="<span class=\"string\">$col3</span>"
    elif [[ "$col3" = "()" ]]; then
      span3="<span class=\"yellow\">$col3</span>"
    elif [[ "$col3" =~ "$" ]]; then
      span3="<span class=\"value\">$col3</span>"
    elif [ "$col3" = "in" ]; then
      span3="<span class=\"purple\">$col3</span>"
    elif [ "$col3" = "then" ] || [ "$col3" = "do" ]; then
      span3="<span class=\"purple\">$col3</span>"
    elif [[ "$col3" =~ "-" ]] || [[ "$col3" =~ "--" ]]; then
      span3="<span class=\"option\">$col3</span>"
    elif [ "$col3" = "true" ] || [ "$col3" = "false" ]; then
      span3="<span class=\"option\">$col3</span>"
    elif [ "$col3" = "[" ]; then
      span3="<span class=\"yellow\">$col3</span>"
    elif [ "$col3" = "basename" ] || [ "$col3" = "exit" ]; then
      span3="<span class=\"command\">$col3</span>"
    elif [ "$col3" = ">>" ] || [ "$col3" = "2>" ] || [ "$col3" = "=" ] || [ "$col3" = ";" ]; then
      span3="<span class=\"white\">$col3</span>"
    elif [[ "$col3" = *"\\\""* ]]; then
      span3="<span class=\"back_slash\">$col3</span>"
    elif [[ "$col3" = "" ]]; then
      span3=""
    else
      span3="<span class=\"string\">$col3</span>"
    fi

    if [ "$col4" = "\"" ] || [ "$col4" = "\"/\"" ] || [ "$col4" = "\")" ] || [ "$col4" = "/\"" ] || [ "$col4" = "/" ]; then
      span4="<span class=\"string\">$col4</span>"
    elif [[ "$col4" =~ "$" ]]; then
      span4="<span class=\"value\">$col4</span>"
    elif [ "$col4" = "then" ] || [ "$col4" = "do" ]; then
      span4="<span class=\"purple\">$col4</span>"
    elif [ "$col4" = "true" ] || [ "$col4" = "false" ]; then
      span4="<span class=\"option\">$col4</span>"
    elif [ "$col4" = "[" ]; then
      span4="<span class=\"yellow\">$col4</span>"
    elif [ "$col4" = "]" ]; then
      span4="<span class=\"yellow\">$col4</span>"
    elif [ "$col4" = "basename" ] || [ "$col4" = "exit" ]; then
      span4="<span class=\"command\">$col4</span>"
    elif [ "$col4" = ">>" ] || [ "$col4" = "2>" ] || [ "$col4" = "=" ] || [ "$col4" = ";" ]; then
      span4="<span class=\"white\">$col4</span>"
    elif [[ "$col4" = *"\\\""* ]]; then
      span4="<span class=\"back_slash\">$col4</span>"
    elif [[ "$col4" = "" ]]; then
      span4=""
    else
      span4="<span class=\"string\">$col4</span>"
    fi

    if [ "$col5" = "\"" ] || [ "$col5" = "\"/\"" ] || [ "$col5" = "\")" ] || [ "$col5" = "/\"" ] || [ "$col5" = "/" ]; then
      span5="<span class=\"string\">$col5</span>"
    elif [[ "$col5" =~ "$" ]]; then
      span5="<span class=\"value\">$col5</span>"
    elif [ "$col5" = "then" ] || [ "$col5" = "do" ]; then
      span5="<span class=\"purple\">$col5</span>"
    elif [[ "$col5" =~ "-" ]] || [[ "$col5" =~ "--" ]]; then
      span5="<span class=\"option\">$col5</span>"
    elif [ "$col5" = "true" ] || [ "$col5" = "false" ]; then
      span5="<span class=\"option\">$col5</span>"
    elif [ "$col5" = "[" ]; then
      span5="<span class=\"yellow\">$col5</span>"
    elif [ "$col5" = "]" ]; then
      span5="<span class=\"yellow\">$col5</span>"
    elif [ "$col5" = "basename" ] || [ "$col5" = "exit" ]; then
      span5="<span class=\"command\">$col5</span>"
    elif [ "$col5" = ">>" ] || [ "$col5" = "2>" ] || [ "$col5" = "=" ] || [ "$col5" = ";" ]; then
      span5="<span class=\"white\">$col5</span>"
    elif [[ "$col5" = *"\\\""* ]]; then
      span5="<span class=\"back_slash\">$col5</span>"
    elif [[ "$col5" = "" ]]; then
      span5=""
    else
      span5="<span class=\"string\">$col5</span>"
    fi

    if [ "$col6" = "\"" ] || [ "$col6" = "\"/\"" ] || [ "$col6" = "\")" ] || [ "$col6" = "/\"" ] || [ "$col6" = "/" ]; then
      span6="<span class=\"string\">$col6</span>"
    elif [[ "$col6" =~ "$" ]]; then
      span6="<span class=\"value\">$col6</span>"
    elif [ "$col6" = "then" ] || [ "$col6" = "do" ]; then
      span6="<span class=\"purple\">$col6</span>"
    elif [[ "$col6" =~ "-" ]] || [[ "$col6" =~ "--" ]]; then
      span6="<span class=\"option\">$col6</span>"
    elif [ "$col6" = "true" ] || [ "$col6" = "false" ]; then
      span6="<span class=\"option\">$col6</span>"
    elif [ "$col6" = "[" ]; then
      span6="<span class=\"yellow\">$col6</span>"
    elif [ "$col6" = "]" ]; then
      span6="<span class=\"yellow\">$col6</span>"
    elif [ "$col6" = "basename" ] || [ "$col6" = "exit" ]; then
      span6="<span class=\"command\">$col6</span>"
    elif [ "$col6" = ">>" ] || [ "$col6" = "2>" ] || [ "$col6" = "=" ] || [ "$col6" = ";" ]; then
      span6="<span class=\"white\">$col6</span>"
    elif [[ "$col6" = *"\\\""* ]]; then
      span6="<span class=\"back_slash\">$col6</span>"
    elif [[ "$col6" = "" ]]; then
      span6=""
    else
      span6="<span class=\"string\">$col6</span>"
    fi

    if [ "$col7" = "\"" ] || [ "$col7" = "\"/\"" ] || [ "$col7" = "\")" ] || [ "$col7" = "/\"" ] || [ "$col7" = "/" ]; then
      span7="<span class=\"string\">$col7</span>"
    elif [[ "$col7" =~ "$" ]]; then
      span7="<span class=\"value\">$col7</span>"
    elif [ "$col7" = "then" ] || [ "$col7" = "do" ]; then
      span7="<span class=\"purple\">$col7</span>"
    elif [[ "$col7" =~ "-" ]] || [[ "$col7" =~ "--" ]]; then
      span7="<span class=\"option\">$col7</span>"
    elif [ "$col7" = "true" ] || [ "$col7" = "false" ]; then
      span7="<span class=\"option\">$col7</span>"
    elif [ "$col7" = "[" ]; then
      span7="<span class=\"yellow\">$col7</span>"
    elif [ "$col7" = "]" ]; then
      span7="<span class=\"yellow\">$col7</span>"
    elif [ "$col7" = "basename" ] || [ "$col7" = "exit" ]; then
      span7="<span class=\"command\">$col7</span>"
    elif [ "$col7" = ">>" ] || [ "$col7" = "2>" ] || [ "$col7" = "=" ] || [ "$col7" = ";" ]; then
      span7="<span class=\"white\">$col7</span>"
    elif [[ "$col7" = *"\\\""* ]]; then
      span7="<span class=\"back_slash\">$col7</span>"
    elif [[ "$col7" = "" ]]; then
      span7=""
    else
      span7="<span class=\"string\">$col7</span>"
    fi

    if [ "$col8" = "\"" ] || [ "$col8" = "\"/\"" ] || [ "$col8" = "\")" ] || [ "$col8" = "/\"" ] || [ "$col8" = "/" ]; then
      span8="<span class=\"string\">$col8</span>"
    elif [[ "$col8" =~ "$" ]]; then
      span8="<span class=\"value\">$col8</span>"
    elif [ "$col8" = "then" ] || [ "$col8" = "do" ]; then
      span8="<span class=\"purple\">$col8</span>"
    elif [[ "$col8" =~ "-" ]] || [[ "$col8" =~ "--" ]]; then
      span8="<span class=\"option\">$col8</span>"
    elif [ "$col8" = "true" ] || [ "$col8" = "false" ]; then
      span8="<span class=\"option\">$col8</span>"
    elif [ "$col8" = "[" ]; then
      span8="<span class=\"yellow\">$col8</span>"
    elif [ "$col8" = "]" ]; then
      span8="<span class=\"yellow\">$col8</span>"
    elif [ "$col8" = "basename" ] || [ "$col8" = "exit" ]; then
      span8="<span class=\"command\">$col8</span>"
    elif [ "$col8" = ">>" ] || [ "$col8" = "2>" ] || [ "$col8" = "=" ] || [ "$col8" = ";" ]; then
      span8="<span class=\"white\">$col8</span>"
    elif [[ "$col8" = *"\\\""* ]]; then
      span8="<span class=\"back_slash\">$col8</span>"
    elif [[ "$col8" = "" ]]; then
      span8=""
    else
      span8="<span class=\"string\">$col8</span>"
    fi

    if [ "$col9" = "\"" ] || [ "$col9" = "\"/\"" ] || [ "$col9" = "\")" ] || [ "$col9" = "/\"" ] || [ "$col9" = "/" ]; then
      span9="<span class=\"string\">$col9</span>"
    elif [[ "$col9" =~ "$" ]]; then
      span9="<span class=\"value\">$col9</span>"
    elif [ "$col9" = "then" ] || [ "$col9" = "do" ]; then
      span9="<span class=\"purple\">$col9</span>"
    elif [[ "$col9" =~ "-" ]] || [[ "$col9" =~ "--" ]]; then
      span9="<span class=\"option\">$col9</span>"
    elif [ "$col9" = "true" ] || [ "$col9" = "false" ]; then
      span9="<span class=\"option\">$col9</span>"
    elif [ "$col9" = "[" ]; then
      span9="<span class=\"yellow\">$col9</span>"
    elif [ "$col9" = "]" ]; then
      span9="<span class=\"yellow\">$col9</span>"
    elif [ "$col9" = "basename" ] || [ "$col9" = "exit" ]; then
      span9="<span class=\"command\">$col9</span>"
    elif [ "$col9" = ">>" ] || [ "$col9" = "2>" ] || [ "$col9" = "=" ] || [ "$col9" = ";" ]; then
      span9="<span class=\"white\">$col9</span>"
    elif [[ "$col9" = *"\\\""* ]]; then
      span9="<span class=\"back_slash\">$col9</span>"
    elif [[ "$col9" = "" ]]; then
      span9=""
    else
      span9="<span class=\"string\">$col9</span>"
    fi

    if [ "$col10" = "\"" ] || [ "$col10" = "\"/\"" ] || [ "$col10" = "\")" ] || [ "$col10" = "/\"" ] || [ "$col10" = "/" ]; then
      span10="<span class=\"string\">$col10</span>"
    elif [[ "$col10" =~ "$" ]]; then
      span10="<span class=\"value\">$col10</span>"
    elif [ "$col10" = "then" ] || [ "$col10" = "do" ]; then
      span10="<span class=\"purple\">$col10</span>"
    elif [[ "$col10" =~ "-" ]] || [[ "$col10" =~ "--" ]]; then
      span10="<span class=\"option\">$col10</span>"
    elif [ "$col10" = "true" ] || [ "$col10" = "false" ]; then
      span10="<span class=\"option\">$col10</span>"
    elif [ "$col10" = "[" ]; then
      span10="<span class=\"yellow\">$col10</span>"
    elif [ "$col10" = "]" ]; then
      span10="<span class=\"yellow\">$col10</span>"
    elif [ "$col10" = "basename" ] || [ "$col10" = "exit" ]; then
      span10="<span class=\"command\">$col10</span>"
    elif [ "$col10" = ">>" ] || [ "$col10" = "2>" ] || [ "$col10" = "=" ] || [ "$col10" = ";" ]; then
      span10="<span class=\"white\">$col10</span>"
    elif [[ "$col10" = *"\\\""* ]]; then
      span10="<span class=\"back_slash\">$col10</span>"
    elif [[ "$col10" = "" ]]; then
      span10=""
    else
      span10="<span class=\"string\">$col10</span>"
    fi

    if [ "$col11" = "\"" ] || [ "$col11" = "\"/\"" ] || [ "$col11" = "\")" ] || [ "$col11" = "/\"" ] || [ "$col11" = "/" ]; then
      span11="<span class=\"string\">$col11</span>"
    elif [[ "$col11" =~ "$" ]]; then
      span11="<span class=\"value\">$col11</span>"
    elif [ "$col11" = "then" ] || [ "$col11" = "do" ]; then
      span11="<span class=\"purple\">$col11</span>"
    elif [[ "$col11" =~ "-" ]] || [[ "$col11" =~ "--" ]]; then
      span11="<span class=\"option\">$col11</span>"
    elif [ "$col11" = "true" ] || [ "$col11" = "false" ]; then
      span11="<span class=\"option\">$col11</span>"
    elif [ "$col11" = "[" ]; then
      span11="<span class=\"yellow\">$col11</span>"
    elif [ "$col11" = "]" ]; then
      span11="<span class=\"yellow\">$col11</span>"
    elif [ "$col11" = "basename" ] || [ "$col11" = "exit" ]; then
      span11="<span class=\"command\">$col11</span>"
    elif [ "$col11" = ">>" ] || [ "$col11" = "2>" ] || [ "$col11" = "=" ] || [ "$col11" = ";" ]; then
      span11="<span class=\"white\">$col11</span>"
    elif [[ "$col11" = *"\\\""* ]]; then
      span11="<span class=\"back_slash\">$col11</span>"
    elif [[ "$col11" = "" ]]; then
      span11=""
    else
      span11="<span class=\"string\">$col11</span>"
    fi

    if [ "$col12" = "\"" ] || [ "$col12" = "\"/\"" ] || [ "$col12" = "\")" ] || [ "$col12" = "/\"" ] || [ "$col12" = "/" ]; then
      span12="<span class=\"string\">$col12</span>"
    elif [[ "$col12" =~ "$" ]]; then
      span12="<span class=\"value\">$col12</span>"
    elif [ "$col12" = "then" ] || [ "$col12" = "do" ]; then
      span12="<span class=\"purple\">$col12</span>"
    elif [[ "$col12" =~ "-" ]] || [[ "$col12" =~ "--" ]]; then
      span12="<span class=\"option\">$col12</span>"
    elif [ "$col12" = "true" ] || [ "$col12" = "false" ]; then
      span12="<span class=\"option\">$col12</span>"
    elif [ "$col12" = "[" ]; then
      span12="<span class=\"yellow\">$col12</span>"
    elif [ "$col12" = "]" ]; then
      span12="<span class=\"yellow\">$col12</span>"
    elif [ "$col12" = "basename" ] || [ "$col12" = "exit" ]; then
      span12="<span class=\"command\">$col12</span>"
    elif [ "$col12" = ">>" ] || [ "$col12" = "2>" ] || [ "$col12" = "=" ] || [ "$col12" = ";" ]; then
      span12="<span class=\"white\">$col12</span>"
    elif [[ "$col12" = *"\\\""* ]]; then
      span12="<span class=\"back_slash\">$col12</span>"
    elif [[ "$col12" = "" ]]; then
      span12=""
    else
      span12="<span class=\"string\">$col12</span>"
    fi

    if [ "$col13" = "\"" ] || [ "$col13" = "\"/\"" ] || [ "$col13" = "\")" ] || [ "$col13" = "/\"" ] || [ "$col13" = "/" ]; then
      span13="<span class=\"string\">$col13</span>"
    elif [[ "$col13" =~ "$" ]]; then
      span13="<span class=\"value\">$col13</span>"
    elif [ "$col13" = "then" ] || [ "$col13" = "do" ]; then
      span13="<span class=\"purple\">$col13</span>"
    elif [[ "$col13" =~ "-" ]] || [[ "$col13" =~ "--" ]]; then
      span13="<span class=\"option\">$col13</span>"
    elif [ "$col13" = "true" ] || [ "$col13" = "false" ]; then
      span13="<span class=\"option\">$col13</span>"
    elif [ "$col13" = "[" ]; then
      span13="<span class=\"yellow\">$col13</span>"
    elif [ "$col13" = "]" ]; then
      span13="<span class=\"yellow\">$col13</span>"
    elif [ "$col13" = "basename" ] || [ "$col13" = "exit" ]; then
      span13="<span class=\"command\">$col13</span>"
    elif [ "$col13" = ">>" ] || [ "$col13" = "2>" ] || [ "$col13" = "=" ] || [ "$col13" = ";" ]; then
      span13="<span class=\"white\">$col13</span>"
    elif [[ "$col13" = *"\\\""* ]]; then
      span13="<span class=\"back_slash\">$col13</span>"
    elif [[ "$col13" = "" ]]; then
      span13=""
    else
      span13="<span class=\"string\">$col13</span>"
    fi

    if [ "$col14" = "\"" ] || [ "$col14" = "\"/\"" ] || [ "$col14" = "\")" ] || [ "$col14" = "/\"" ] || [ "$col14" = "/" ]; then
      span14="<span class=\"string\">$col14</span>"
    elif [[ "$col14" =~ "$" ]]; then
      span14="<span class=\"value\">$col14</span>"
    elif [ "$col14" = "then" ] || [ "$col14" = "do" ]; then
      span14="<span class=\"purple\">$col14</span>"
    elif [[ "$col14" =~ "-" ]] || [[ "$col14" =~ "--" ]]; then
      span14="<span class=\"option\">$col14</span>"
    elif [ "$col14" = "true" ] || [ "$col14" = "false" ]; then
      span14="<span class=\"option\">$col14</span>"
    elif [ "$col14" = "[" ]; then
      span14="<span class=\"yellow\">$col14</span>"
    elif [ "$col14" = "]" ]; then
      span14="<span class=\"yellow\">$col14</span>"
    elif [ "$col14" = "basename" ] || [ "$col14" = "exit" ]; then
      span14="<span class=\"command\">$col14</span>"
    elif [ "$col14" = ">>" ] || [ "$col14" = "2>" ] || [ "$col14" = "=" ] || [ "$col14" = ";" ]; then
      span14="<span class=\"white\">$col14</span>"
    elif [[ "$col14" = *"\\\""* ]]; then
      span14="<span class=\"back_slash\">$col14</span>"
    elif [[ "$col14" = "" ]]; then
      span14=""
    else
      span14="<span class=\"string\">$col14</span>"
    fi

    if [ "$col15" = "\"" ] || [ "$col15" = "\"/\"" ] || [ "$col15" = "\")" ] || [ "$col15" = "/\"" ] || [ "$col15" = "/" ]; then
      span15="<span class=\"string\">$col15</span>"
    elif [[ "$col15" =~ "$" ]]; then
      span15="<span class=\"value\">$col15</span>"
    elif [ "$col15" = "then" ] || [ "$col15" = "do" ]; then
      span15="<span class=\"purple\">$col15</span>"
    elif [[ "$col15" =~ "-" ]] || [[ "$col15" =~ "--" ]]; then
      span15="<span class=\"option\">$col15</span>"
    elif [ "$col15" = "true" ] || [ "$col15" = "false" ]; then
      span15="<span class=\"option\">$col15</span>"
    elif [ "$col15" = "[" ]; then
      span15="<span class=\"yellow\">$col15</span>"
    elif [ "$col15" = "]" ]; then
      span15="<span class=\"yellow\">$col15</span>"
    elif [ "$col15" = "basename" ] || [ "$col15" = "exit" ]; then
      span15="<span class=\"command\">$col15</span>"
    elif [ "$col15" = ">>" ] || [ "$col15" = "2>" ] || [ "$col15" = "=" ] || [ "$col15" = ";" ]; then
      span15="<span class=\"white\">$col15</span>"
    elif [[ "$col15" = *"\\\""* ]]; then
      span15="<span class=\"back_slash\">$col15</span>"
    elif [[ "$col15" = "" ]]; then
      span15=""
    else
      span15="<span class=\"string\">$col15</span>"
    fi

    if [ "$col16" = "\"" ] || [ "$col16" = "\"/\"" ] || [ "$col16" = "\")" ] || [ "$col16" = "/\"" ] || [ "$col16" = "/" ]; then
      span16="<span class=\"string\">$col16</span>"
    elif [[ "$col16" =~ "$" ]]; then
      span16="<span class=\"value\">$col16</span>"
    elif [ "$col16" = "then" ] || [ "$col16" = "do" ]; then
      span16="<span class=\"purple\">$col16</span>"
    elif [[ "$col16" =~ "-" ]] || [[ "$col16" =~ "--" ]]; then
      span16="<span class=\"option\">$col16</span>"
    elif [ "$col16" = "true" ] || [ "$col16" = "false" ]; then
      span16="<span class=\"option\">$col16</span>"
    elif [ "$col16" = "[" ]; then
      span16="<span class=\"yellow\">$col16</span>"
    elif [ "$col16" = "]" ]; then
      span16="<span class=\"yellow\">$col16</span>"
    elif [ "$col16" = "basename" ] || [ "$col16" = "exit" ]; then
      span16="<span class=\"command\">$col16</span>"
    elif [ "$col16" = ">>" ] || [ "$col16" = "2>" ] || [ "$col16" = "=" ] || [ "$col16" = ";" ]; then
      span16="<span class=\"white\">$col16</span>"
    elif [[ "$col16" = *"\\\""* ]]; then
      span16="<span class=\"back_slash\">$col16</span>"
    elif [[ "$col16" = "" ]]; then
      span16=""
    else
      span16="<span class=\"string\">$col16</span>"
    fi

    if [ "$col17" = "\"" ] || [ "$col17" = "\"/\"" ] || [ "$col17" = "\")" ] || [ "$col17" = "/\"" ] || [ "$col17" = "/" ]; then
      span17="<span class=\"string\">$col17</span>"
    elif [[ "$col17" =~ "$" ]]; then
      span17="<span class=\"value\">$col17</span>"
    elif [ "$col17" = "then" ] || [ "$col17" = "do" ]; then
      span17="<span class=\"purple\">$col17</span>"
    elif [[ "$col17" =~ "-" ]] || [[ "$col17" =~ "--" ]]; then
      span17="<span class=\"option\">$col17</span>"
    elif [ "$col17" = "true" ] || [ "$col17" = "false" ]; then
      span17="<span class=\"option\">$col17</span>"
    elif [ "$col17" = "[" ]; then
      span17="<span class=\"yellow\">$col17</span>"
    elif [ "$col17" = "]" ]; then
      span17="<span class=\"yellow\">$col17</span>"
    elif [ "$col17" = "basename" ] || [ "$col17" = "exit" ] || [ "$col17" = "=" ] || [ "$col17" = ";" ]; then
      span17="<span class=\"command\">$col17</span>"
    elif [ "$col17" = ">>" ] || [ "$col17" = "2>" ]; then
      span17="<span class=\"white\">$col17</span>"
    elif [[ "$col17" = *"\\\""* ]]; then
      span17="<span class=\"back_slash\">$col17</span>"
    elif [[ "$col17" = "" ]]; then
      span17=""
    else
      span17="<span class=\"string\">$col17</span>"
    fi

    if [ "$col18" = "\"" ] || [ "$col18" = "\"/\"" ] || [ "$col18" = "\")" ] || [ "$col18" = "/\"" ] || [ "$col18" = "/" ]; then
      span18="<span class=\"string\">$col18</span>"
    elif [[ "$col18" =~ "$" ]]; then
      span18="<span class=\"value\">$col18</span>"
    elif [ "$col18" = "then" ] || [ "$col18" = "do" ]; then
      span18="<span class=\"purple\">$col18</span>"
    elif [[ "$col18" =~ "-" ]] || [[ "$col18" =~ "--" ]]; then
      span18="<span class=\"option\">$col18</span>"
    elif [ "$col18" = "true" ] || [ "$col18" = "false" ]; then
      span18="<span class=\"option\">$col18</span>"
    elif [ "$col18" = "[" ]; then
      span18="<span class=\"yellow\">$col18</span>"
    elif [ "$col18" = "]" ]; then
      span18="<span class=\"yellow\">$col18</span>"
    elif [ "$col18" = "basename" ] || [ "$col18" = "exit" ]; then
      span18="<span class=\"command\">$col18</span>"
    elif [ "$col18" = ">>" ] || [ "$col18" = "2>" ] || [ "$col18" = "=" ] || [ "$col18" = ";" ]; then
      span18="<span class=\"white\">$col18</span>"
    elif [[ "$col18" = *"\\\""* ]]; then
      span18="<span class=\"back_slash\">$col18</span>"
    elif [[ "$col18" = "" ]]; then
      span18=""
    else
      span18="<span class=\"string\">$col18</span>"
    fi

    if [ "$col19" = "\"" ] || [ "$col19" = "\"/\"" ] || [ "$col19" = "\")" ] || [ "$col19" = "/\"" ] || [ "$col19" = "/" ]; then
      span19="<span class=\"string\">$col19</span>"
    elif [[ "$col19" =~ "$" ]]; then
      span19="<span class=\"value\">$col19</span>"
    elif [ "$col19" = "then" ] || [ "$col19" = "do" ]; then
      span19="<span class=\"purple\">$col19</span>"
    elif [[ "$col19" =~ "-" ]] || [[ "$col19" =~ "--" ]]; then
      span19="<span class=\"option\">$col19</span>"
    elif [ "$col19" = "true" ] || [ "$col19" = "false" ]; then
      span19="<span class=\"option\">$col19</span>"
    elif [ "$col19" = "[" ]; then
      span19="<span class=\"yellow\">$col19</span>"
    elif [ "$col19" = "]" ]; then
      span19="<span class=\"yellow\">$col19</span>"
    elif [ "$col19" = "basename" ] || [ "$col19" = "exit" ]; then
      span19="<span class=\"command\">$col19</span>"
    elif [ "$col19" = ">>" ] || [ "$col19" = "2>" ] || [ "$col19" = "=" ] || [ "$col19" = ";" ]; then
      span19="<span class=\"white\">$col19</span>"
    elif [[ "$col19" = *"\\\""* ]]; then
      span19="<span class=\"back_slash\">$col19</span>"
    elif [[ "$col19" = "" ]]; then
      span19=""
    else
      span19="<span class=\"string\">$col19</span>"
    fi

    if [ "$col20" = "\"" ] || [ "$col20" = "\"/\"" ] || [ "$col20" = "\")" ] || [ "$col20" = "/\"" ] || [ "$col20" = "/" ]; then
      span20="<span class=\"string\">$col20</span>"
    elif [[ "$col20" =~ "$" ]]; then
      span20="<span class=\"value\">$col20</span>"
    elif [ "$col20" = "then" ] || [ "$col20" = "do" ]; then
      span20="<span class=\"purple\">$col20</span>"
    elif [[ "$col20" =~ "-" ]] || [[ "$col20" =~ "--" ]]; then
      span20="<span class=\"option\">$col20</span>"
    elif [ "$col20" = "true" ] || [ "$col20" = "false" ]; then
      span20="<span class=\"option\">$col20</span>"
    elif [ "$col20" = "[" ]; then
      span20="<span class=\"yellow\">$col20</span>"
    elif [ "$col20" = "]" ]; then
      span20="<span class=\"yellow\">$col20</span>"
    elif [ "$col20" = "basename" ] || [ "$col20" = "exit" ]; then
      span20="<span class=\"command\">$col20</span>"
    elif [ "$col20" = ">>" ] || [ "$col20" = "2>" ] || [ "$col20" = "=" ] || [ "$col20" = ";" ]; then
      span20="<span class=\"white\">$col20</span>"
    elif [[ "$col20" = *"\\\""* ]]; then
      span20="<span class=\"back_slash\">$col20</span>"
    elif [[ "$col20" = "" ]]; then
      span20=""
    else
      span20="<span class=\"string\">$col20</span>"
    fi
    echo "${span1} ${span2}${span3}${span4}${span5}${span6}${span7}${span8}${span9}${span10}${span11}${span12}${span13}${span14}${span15}${span16}${span17}${span18}${span19}${span20}" >> "$current_dir/$main_file.html"
  done < "$sub_file"

  rm "$sub_file"

  cat << EOF >> "$current_dir/$main_file.html"

<style>
  #html-box,#css-box,#js-box {
    background: repeating-linear-gradient( to top,rgba(255,255,255,0.03) 0px 2px,transparent 2px 4px ),linear-gradient(to bottom,#200933 75%,#3d0b43)
  }

  #html-box::after,#css-box::after,#js-box::after {
    content: '';
    height: 50%;
    width: 100%;
    /* display: block; */
    background-image: linear-gradient(90deg,rgba(252,25,154,.1) 1px,rgba(0,0,0,0) 1px),linear-gradient(0deg,rgba(252,25,154,.1) 1px,rgba(0,0,0,0) 1px);
    background-position: bottom;
    /* background-repeat: repeat; */
    background-size: 20px 20px;
    /* left: -25px; */
    position: absolute;
    /* pointer-events: none; */
    bottom: 0;
    transform: perspective(100px) rotateX(60deg);
    z-index: 0
  }

  .value {
    color: #3fefff
  }
  .option {
    color: #005eff;
  }
  .string {
    color: #c6804e;
  }
  .memo {
    color: #008600;
  }
  .command {
    color: #d5cb85;
  }
  .integer {
    color: #c4ffb4;
  }
  .back_slash{
    color: #e3df9d;
  }
  .yellow {
    color: #fff570;
  }
  .purple {
    color: #b869d7;
  }
  .white {
    color: white
  }

  body.editor {
    background: #131417
  }

  .box.box.box,.editor .top-boxes,body.project .editor-pane,body.project .editor {
    background: #131417
  }

  .box.box.box pre,.editor .top-boxes pre,pre,body.project .editor-pane pre,body.project .editor pre {
    color: #d5d7de
  }

  code[class] .value,code[class] {
    color: #3fefff;
    text-shadow: 0 0 2px #393a33,0 0 35px #ffffff44,0 0 10px #3fefff,0 0 1px #3fefff;
  }

  code[class] .option,code[class] {
    color: #005eff;
    text-shadow: 0 0 2px #393a33,0 0 35px #ffffff44,0 0 10px #005eff,0 0 2px #005eff;
  }

  code[class] .string,code[class] {
    color: #c6804e;
    text-shadow: 0 0 2px #393a33,0 0 35px #ffffff44,0 0 10px #c6804e,0 0 1px #c6804e;
  }

  code[class] .memo,code[class] {
    color: #008600;
    text-shadow: 0 0 2px #393a33,0 0 35px #ffffff44,0 0 10px #008600,0 0 2px #008600;
  }

  code[class] .command,code[class] {
    color: #d5cb85;
    text-shadow: 0 0 2px #393a33,0 0 35px #ffffff44,0 0 10px #d5cb85,0 0 1px #d5cb85;
  }

  code[class] .integer,code[class] {
    color: #c4ffb4;
    text-shadow: 0 0 2px #393a33,0 0 35px #ffffff44,0 0 10px #c4ffb4,0 0 2px #c4ffb4;
  }

  code[class] .back_slash,code[class] {
    color: #e3df9d;
    text-shadow: 0 0 2px #100c0f,0 0 35px #ffffff44,0 0 5px #e3df9d,0 0 10px #e3df9d;
  }

  code[class] .yellow,code[class] {
    color: #fff570;
    text-shadow: 0 0 2px #100c0f,0 0 35px #ffffff44,0 0 5px #fff570,0 0 2px #fff570;
  }

  code[class] .purple,code[class] {
    color: #b869d7;
    text-shadow: 0 0 2px #100c0f,0 0 35px #ffffff44,0 0 5px #b869d7,0 0 2px #b869d7;
  }

  code[class] .white,code[class] {
    color: white;
    text-shadow: 0 0 2px #100c0f,0 0 35px #ffffff44,0 0 5px white,0 0 2px white;
  }

  * {
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
    margin: 0;
    padding: 0
  }

  html,body {
    height: 100%;
  }

  .embed-line-highlight {
    background: rgba(212,214,223,.2)
  }

  #output {
    /* height: calc(100% - 50px - 30px); */
    height: calc(100%);
  }

  #output pre {
    font-size: 20px;
    white-space: pre-wrap;
    line-height: 1.35;
    -moz-tab-size: 2;
    -o-tab-size: 2;
    tab-size: 2;
    max-width: 100vw
  }

  #output pre code {
    font-family: var(--cp-font-family-monospace)
  }

  body.static #output pre,#output.static pre {
    width: 100%;
    padding: 20px
  }

  #output pre,#output iframe {
    scrollbar-color: rgba(0,0,0,.5) transparent;
    height: 100%;
    overflow: auto;
    -webkit-overflow-scrolling: touch
  }

  #html-box.active,#css-box.active,#js-box.active,#result-box.active {
    display: block;
    height: 100%
  }

  :root {
    background: var(--cp-bg);
    color: var(--cp-color);
    --cp-button-default-bg: var(--cp-button-bg);
    --cp-button-default-color: var(--cp-button-color);
    --cp-sidebar-width: 180px;
    --cp-header-height: 65px;
    --cp-header-height-small: 53px;
    --cp-control-bar-height: 29px;
    --cp-control-bar-space-between: 1.5rem;
    --cp-font-family: 'Lato', 'Lucida Grande', 'Lucida Sans Unicode', Tahoma, Sans-Serif;
    --cp-font-family-header: 'Telefon Black', Sans-Serif;
    --cp-font-family-header-alt: 'Telefon', Sans-Serif;
    --cp-font-family-monospace: SFMono-Regular, Consolas, 'Liberation Mono', Menlo, monospace;
    --cp-font-family-editor: var(--cp-font-family-monospace);
    --cp-button-icon: currentColor;
    --cp-button-border-width: 3px;
    --cp-button-border-radius: 4px;
    --cp-button-margin-block: 1px;
    --cp-button-margin-inline: 10px;
    --cp-button-padding-inline: 16px;
    --cp-button-padding-block: 10px;
    --cp-pen-radius: 5px;
    --cp-pen-logo-size: 30px;
    --cp-pen-header-spacing: calc(var(--cp-pen-sidebar-spacing) * 1.5);
    --cp-pen-sidebar-width: 60px;
    --cp-pen-sidebar-icon-size: 26px;
    --cp-pen-sidebar-spacing: 6px;
    --cp-pen-sidebar-minimal-width: 6px;
    --cp-pen-panel-spacing: 0.7rem;
    --cp-pen-bar-height: 45px
  }

  @media(max-width: 1100px) {
    :root {
        --cp-pen-sidebar-width: 50px;
        --cp-pen-sidebar-spacing: 4px;
        --cp-pen-sidebar-icon-size: 24px;
        --cp-pen-sidebar-minimal-width: 6px;
        --cp-pen-panel-spacing: 0.6rem
    }
  }

  * {
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
    margin: 0;
    padding: 0
  }

  html,body {
    height: 100%;
  }

  .embed-line-highlight {
    background: rgba(212,214,223,.2)
  }

  #output {
    /* height: calc(100% - 50px - 30px); */
    height: calc(100%);
  }

  #output pre {
    font-size: 20px;
    white-space: pre-wrap;
    line-height: 1.35;
    -moz-tab-size: 2;
    -o-tab-size: 2;
    tab-size: 2;
    max-width: 100vw
  }

  #output pre code {
    font-family: var(--cp-font-family-monospace)
  }

  body.static #output pre,#output.static pre {
    width: 100%;
    padding: 20px
  }

  #output pre,#output iframe {
    scrollbar-color: rgba(0,0,0,.5) transparent;
    height: 100%;
    overflow: auto;
    -webkit-overflow-scrolling: touch
  }
</style>
EOF
}

while true; do
  read -p "HTMLコードを構築したいファイルの名前を入力して下さい: " main_file
  if [ -e "$current_dir"/"$main_file" ]; then
    if [ "$main_file" != "" ]; then
      cd "$current_dir" || exit
      build_HTML_ShellCode
      break
    else
      echo -e "\033[1;31mERROR: ファイル名を入力してください\033[0m"
      echo
      continue
    fi
  elif [ ! -e "$current_dir"/"$main_file" ]; then
    echo -e "\033[1;33mWARNING: 指定されたファイル \"$main_file\" は存在しません。他のファイル名を入力してください\033[0m"
    echo
    continue
  fi
done
