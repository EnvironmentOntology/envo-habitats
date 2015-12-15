
env_eol_mapping_to_taxonomies.tar.gz:
	wget http://environments.jensenlab.org/$@ -O $@

eol_env_annotations_noParentTerms.tar.gz:
	wget http://download.jensenlab.org/EOL/$@

eolenv.pro: eol_env_annotations_noParentTerms.tsv
	tbl2p -p eolenv $< > $@

taxenv_slim.pro:
	blip-findall  -i redlist.pro -r eolmap -r ncbitaxon -i eolenv.pro -consult makehab.pro taxenv/3 -write_prolog > $@.tmp && sort -u $@.tmp > $@

redlist-habitat.obo:
	blip-findall -debug e  -i taxenv_slim.pro  -r envo -r taxonomy -consult makehab.pro whab > $@
