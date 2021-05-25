zipcode.json: tmp/ken_all.jsonl tmp/jigyosyo.jsonl bin/jq
	bin/jq --slurpfile ken_all tmp/ken_all.jsonl --slurpfile jigyosyo tmp/jigyosyo.jsonl -n -c '[$$ken_all[]|{key:.zip,value:"\(.pref)\(.city)\(.town)"}]+[$$jigyosyo[]|{key:.zip7,value:"\(.pref)\(.city)\(.town)\(.address)"}]|from_entries' > $@

tmp/ken_all.jsonl: tmp/KEN_ALL.CSV bin/ken_all
	bin/ken_all address $< -t json > $@

tmp/jigyosyo.jsonl: tmp/JIGYOSYO.CSV bin/ken_all
	bin/ken_all office $< -t json > $@

tmp/KEN_ALL.CSV: tmp/ken_all.zip
	unzip -o -d tmp $<

tmp/JIGYOSYO.CSV: tmp/jigyosyo.zip
	unzip -o -d tmp $<

tmp/ken_all.zip: tmp
	wget -q -O $@ https://www.post.japanpost.jp/zipcode/dl/kogaki/zip/ken_all.zip

tmp/jigyosyo.zip: tmp
	wget -q -O $@ https://www.post.japanpost.jp/zipcode/dl/jigyosyo/zip/jigyosyo.zip

bin/ken_all: bin
	wget -q -O $@ https://github.com/inouet/ken-all/releases/download/v0.0.3/ken-all_linux_amd64
	@chmod +x $@

bin/jq: bin
	wget -q -O $@ https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
	@chmod +x $@

tmp:
	mkdir -p tmp

bin:
	mkdir -p bin

.PHONY: clean
clean:
	rm -rf tmp bin
