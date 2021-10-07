## code to prepare `cat_df` dataset goes here
cat_df = whesApp:::define_categories()
usethis::use_data(cat_df, overwrite = TRUE)
