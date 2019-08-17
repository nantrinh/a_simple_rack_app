select id, set_id, substring(term, 1, 20) as term, substring(definition, 1, 20) as def from cards limit 10;

select id, set_id, substring(term, length(term)-20) as term, substring(definition, length(definition) - 20) as def from cards limit 10;
