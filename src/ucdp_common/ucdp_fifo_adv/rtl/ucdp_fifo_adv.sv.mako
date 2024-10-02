<%inherit file="sv.mako"/>\

<%def name="logic(*args, **kwargs)">\
${parent.logic(*args, **kwargs)}\

  // ------------------------------------------------------
  //  Chain Logic
  // ------------------------------------------------------
% for idx in range(1, len(mod.seg_depths)):
  assign to${idx}_s = ~empty${idx-1}_s & ~full${idx}_s;
% endfor

  // ------------------------------------------------------
  //  Status
  // ------------------------------------------------------
  assign empty_o = ${join_signals(mod, " & ", "empty")};
  assign full_o = ${join_signals(mod, " & ", "full")};
  assign accept_o = ~full0_s;
  assign valid_o = ~empty${len(mod.seg_depths)-1}_s;
  assign filling_s = ${join_signals(mod, " + ", "filling")};
  assign filling_o = filling_s;
% if mod.max_filling:
  assign max_filling_o = max_filling_r;
% endif
</%def>

<%def name="join_signals(mod, operator, name)">\
${operator.join(["%s%d_s" % (name, idx) for idx in range(len(mod.seg_depths))])}\
</%def>
