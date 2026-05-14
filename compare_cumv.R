library(dplyr)

fish <- read.csv("fish_collection.csv")

# Get the column names so we can check them
colnames(fish)

# Pick a random genus/species combination from the first file
random_taxon <- fish %>%
  select(Genus = `X1.9.determinations.4.taxon.Genus`,
         Species = `X1.9.determinations.4.taxon.Species`) %>%
  distinct() %>% 
  sample_n(50)

random_taxon

# export the random list
write.csv(random_taxon, "random_taxon_v1.csv")

# Compare unique CUMV Catalog Numbers between app and specify exports
# Compares 50 paired query CSV files and reports mismatches

results <- list()

for (i in 1:50) {
  query_id <- sprintf("%02d", i)
  
  app_file     <- paste0("app_portal/filtered_specimens_", query_id, ".csv")
  specify_file <- paste0("specify_portal/", query_id, ".csv")
  
  # Skip if either file is missing
  if (!file.exists(app_file) || !file.exists(specify_file)) {
    message("Query ", query_id, ": one or both files not found — skipping.")
    next
  }
  
  app_data     <- read.csv(app_file,     stringsAsFactors = FALSE)
  specify_data <- read.csv(specify_file, stringsAsFactors = FALSE)
  
  # Extract unique CUMV numbers from each portal
  app_cumv     <- unique(trimws(as.character(app_data$CUMV.Catalog.Number)))
  specify_cumv <- unique(trimws(as.character(specify_data$CatNum)))
  
  # Remove NAs
  app_cumv     <- app_cumv[!is.na(app_cumv) & app_cumv != ""]
  specify_cumv <- specify_cumv[!is.na(specify_cumv) & specify_cumv != ""]
  
  # Find differences
  in_app_not_specify <- setdiff(app_cumv, specify_cumv)
  in_specify_not_app <- setdiff(specify_cumv, app_cumv)
  
  match_status <- if (length(in_app_not_specify) == 0 && length(in_specify_not_app) == 0) {
    "MATCH"
  } else {
    "MISMATCH"
  }
  
  results[[query_id]] <- list(
    query            = query_id,
    status           = match_status,
    n_unique_app     = length(app_cumv),
    n_unique_specify = length(specify_cumv),
    only_in_app      = in_app_not_specify,
    only_in_specify  = in_specify_not_app
  )
  
  cat(sprintf("Query %s: %s | unique app=%d | unique specify=%d",
              query_id, match_status,
              length(app_cumv), length(specify_cumv)))
  
  if (match_status == "MISMATCH") {
    if (length(in_app_not_specify) > 0)
      cat(sprintf("\n  Only in app_portal     : %s", paste(in_app_not_specify, collapse = ", ")))
    if (length(in_specify_not_app) > 0)
      cat(sprintf("\n  Only in specify_portal : %s", paste(in_specify_not_app, collapse = ", ")))
  }
  cat("\n")
}

# ── Summary table ────────────────────────────────────────────────────────────
summary_df <- do.call(rbind, lapply(results, function(r) {
  data.frame(
    Query            = r$query,
    Status           = r$status,
    Unique_App       = r$n_unique_app,
    Unique_Specify   = r$n_unique_specify,
    Only_In_App      = paste(r$only_in_app,     collapse = "; "),
    Only_In_Specify  = paste(r$only_in_specify, collapse = "; "),
    stringsAsFactors = FALSE
  )
}))

# Save full summary to CSV
write.csv(summary_df, "cumv_comparison_results.csv", row.names = FALSE)

