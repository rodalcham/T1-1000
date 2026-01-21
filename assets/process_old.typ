  METHOD process.
    ASSERT state = osinitialized.
    protocol = create_protocol( ).
    cl_protocol_tril=>set_display_hedge_log( _str_selection-hedgelog ).
    cl_detailed_log_amrt=>set_display_amort_log( _str_selection-amortlog ).

    select_positions( ).
    " Check if we have to display the positions
    IF stop_after_display_pos( ).
      RETURN.
    ENDIF.
    IF _str_selection-dbt_upd_cat = 2.
      DATA(dbt_wrapper) = lcf_tlv_internal_factory=>get( )->get_dbt_wrapper( ).
      dbt_wrapper->set_data( ... ).
    ENDIF.
    " process the positions
    CASE _str_selection-impairment.
      WHEN abap_true.
        process_imp( ).
        manage_output_imp( ).
				
      WHEN abap_false.
        IF is_serial_processing( ).
          process_val_ser( ).
        ELSE.
          process_val_parallel( ).
        ENDIF.
        IF dbt_wrapper IS BOUND.
          DATA(dbt_protocol_handler) = dbt_wrapper->execute( ).
          protocol->merge_protocol_handler( CHANGING ch_protocol_handler = dbt_protocol_handler ).
        ENDIF.
        manage_output_val( ).
    ENDCASE.
  ENDMETHOD.