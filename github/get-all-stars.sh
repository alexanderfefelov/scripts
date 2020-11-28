#!/usr/bin/env bash

readonly USERNAME=${1:-alexanderfefelov}

readonly STARS=$(http --headers GET https://api.github.com/users/$USERNAME/starred per_page==1 | egrep '^link' | egrep -o 'page=[0-9]+' | tail -1 | cut -c6-)

readonly PAGE_SIZE=100
readonly PAGES=$(($STARS/$PAGE_SIZE+1))
for n in `seq $PAGES`; do
  http --body GET \
    https://api.github.com/users/$USERNAME/starred \
    "Accept: application/vnd.github.v3.star+json" \
    per_page==$PAGE_SIZE \
    page==$n \
    | jq -r '.[] | [.starred_at, .repo.full_name, .repo.created_at, .repo.updated_at, .repo.archived, .repo.language, .repo.stargazers_count, .repo.description] | @tsv'
done
