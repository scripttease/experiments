if (ctx._source.interaction == null) {
  ctx._source.interaction = [newinteraction]
} else if (ctx._source.interaction instanceof Collection) {
  ctx._source.interaction = ctx._source.interaction.push(newinteraction)
} else {
  ctx._source.interaction = [ctx._source.interaction, newinteraction]
}
