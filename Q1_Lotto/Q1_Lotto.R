library(httr)
library(rvest)
library(stringr)

start_no = 1
end_no = 10

lotto_data = list()

for (i in start_no:end_no){
  data_lotto = POST(
    url = "https://www.dhlottery.co.kr/gameResult.do?method=byWin",
    body = list(
      drwNo = as.character(i),
      dwrNoList = as.character(i)
    )
  )

data_lotto_html = data_lotto %>%  read_html()

win_numbers = data_lotto_html %>% 
  html_nodes('.num.win') %>% 
  html_text %>% 
  str_extract_all('\\d+') %>% 
  unlist()

lotto_data[[i]] = win_numbers

Sys.sleep(2)
}

print(lotto_data)
