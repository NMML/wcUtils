#' Parse a *-Behavior.csv file into a proper data.frame
#'
#' @param behav_file file path or file connection to a *-Behavior.csv file
#' @param to_lower whether to convert the column names to lower case
#' @param fix_csv whether to attempt to fix any comma, csv issues
#'
#' @return a data frame
#' @export
read_behav <- function(behav_file,to_lower = TRUE, fix_csv = FALSE) {
  if (fix_csv) {
    fixCSV(behav_file,overwrite = TRUE)
  }

  col_types <- readr::cols_only(
    DeployID = readr::col_character(),
    Ptt = readr::col_character(),
    DepthSensor = readr::col_character(),
    Source = readr::col_character(),
    Instr = readr::col_character(),
    Count = readr::col_integer(),
    Start = readr::col_datetime("%H:%M:%S %d-%b-%Y"),
    End = readr::col_datetime("%H:%M:%S %d-%b-%Y"),
    What = readr::col_character(),
    Number = readr::col_integer(),
    Shape = readr::col_character(),
    DepthMin = readr::col_double(),
    DepthMax = readr::col_double(),
    DurationMin = readr::col_double(),
    DurationMax = readr::col_double(),
    Shallow = readr::col_integer(),
    Deep = readr::col_integer()
  )
  
  behav_df <- readr::read_csv(behav_file,col_types = col_types) %>% 
    janitor::clean_names() %>% 
    dplyr::rename(deployid = deploy_id)
  
  behav_df <- behav_df %>% 
    dplyr::group_by(deployid) %>% 
    dplyr::arrange(deployid,start) %>%
    data.frame()
  
  return(behav_df)
  
}