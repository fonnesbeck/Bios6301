* Import data
insheet using haart1.csv, comma names clear
* Generate unique id
gen id = _n
* Split initreg
split initreg, p(",") gen(drug)
* Create long table with a column for drug
reshape long drug, i(id)
* Generate local macro list of drugs
levelsof drug, local(druglevels)
* Create indicator variable for each drug
foreach d of local druglevels {
  egen drug_`d' = max(drug=="`d'"), by(id)
}
* Reshape to eliminate duplicate rows
reshape wide
* Eliminate drug variables
drop drug1-drug5
