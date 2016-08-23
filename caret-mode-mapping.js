function exoticModeMap (lhs, rhs, optionalModes) {
  let noremap = true,
      silent = true,
      urls = void 0,
      specifiedModes = optionalModes || [modes.CARET, modes.HINTS, modes.EMBED, modes.CUSTOM, modes.EX, modes.PROMPT];

  rhs = mappings._expandLeader(rhs);

  mappings.addUserMap(
    specifiedModes,
    //[modes.INSERT],
    [lhs],
    "User defined mapping",
    function (count) {
      events.feedkeys((count || "") + rhs, noremap, silent);
    },
    {
        count: true,
        rhs: events.canonicalKeys(rhs),
        noremap: !!noremap,
        silent: silent,
        matchingUrls: urls
    }
  );
}

exoticModeMap('jk', '<Esc>') // not working for hint mode.... yet
exoticModeMap('jk', '<Esc>', [modes.INSERT, modes.TEXTAREA])

exoticModeMap('C_h', 'gT', [modes.INSERT, modes.TEXTAREA])
exoticModeMap('C_l', 'gt', [modes.INSERT, modes.TEXTAREA])
