  pselection->setpostingmode( pmpost ).
  pselection->setposmanproc( so_proc[] ).
  pselection->setfipostingdata( ... ).
  pselection->setexcludes( ... ).

  " Selection is prepared, now we can create a workingstock
  PERFORM mt_run_attr.
  DATA(pworkingstock) = NEW cl_workingstock_tlv( ).
  pworkingstock->initialize( im_selection = pselection ).
  " process workingstock
  pworkingstock->process( ).