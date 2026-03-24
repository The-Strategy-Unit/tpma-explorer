# ui

    Code
      ui
    Output
      <div class="form-group shiny-input-container">
        <div class="checkbox">
          <label>
            <input id="test-strategy_care_shift_checkbox" type="checkbox" class="shiny-input-checkbox"/>
            <span>
              <bslib-tooltip placement="auto" bsOptions="[]" data-require-bs-version="5" data-require-bs-caller="tooltip()">
                <template><p>Refine TPMA options to the 55 care-shift-related TPMAs?
      Note: you can widen this sidebar or collapse sections.</p>
      </template>
                Filter for care-shift TPMAs
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" class="bi bi-info-circle " style="height:1em;width:1em;fill:currentColor;vertical-align:-0.125em;" aria-hidden="true" role="img" ><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"></path>
      <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533L8.93 6.588zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0z"></path></svg>
              </bslib-tooltip>
            </span>
          </label>
        </div>
      </div>
      <div class="form-group shiny-input-container">
        <label class="control-label" id="test-strategy_activity_type_select-label" for="test-strategy_activity_type_select">
          <bslib-tooltip placement="auto" bsOptions="[]" data-require-bs-version="5" data-require-bs-caller="tooltip()">
            <template><p>Refine TPMA options to a given activity type.
      Note: you can widen this sidebar or collapse sections.</p>
      </template>
            Filter by activity type
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" class="bi bi-info-circle " style="height:1em;width:1em;fill:currentColor;vertical-align:-0.125em;" aria-hidden="true" role="img" ><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"></path>
      <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533L8.93 6.588zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0z"></path></svg>
          </bslib-tooltip>
        </label>
        <div>
          <select id="test-strategy_activity_type_select" class="shiny-input-select"><option value="ip" selected>Inpatients</option>
      <option value="op">Outpatients</option>
      <option value="ae">Accident &amp; Emergency</option></select>
          <script type="application/json" data-for="test-strategy_activity_type_select" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
        </div>
      </div>
      <div class="form-group shiny-input-container">
        <label class="control-label" id="test-strategy_category_select-label" for="test-strategy_category_select">
          <bslib-tooltip placement="auto" bsOptions="[]" data-require-bs-version="5" data-require-bs-caller="tooltip()">
            <template><p>Refine TPMA options to a given TPMA category within an activity type.
      Note: you can widen this sidebar or collapse sections.</p>
      </template>
            Filter by TPMA category
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" class="bi bi-info-circle " style="height:1em;width:1em;fill:currentColor;vertical-align:-0.125em;" aria-hidden="true" role="img" ><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"></path>
      <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533L8.93 6.588zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0z"></path></svg>
          </bslib-tooltip>
        </label>
        <div>
          <select id="test-strategy_category_select" class="shiny-input-select"></select>
          <script type="application/json" data-for="test-strategy_category_select" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
        </div>
      </div>
      <div class="form-group shiny-input-container">
        <label class="control-label" id="test-strategy_select-label" for="test-strategy_select">
          <bslib-tooltip placement="auto" bsOptions="[]" data-require-bs-version="5" data-require-bs-caller="tooltip()">
            <template><p>Select a TPMA for which to display data.
      To search: delete the selection and start typing.
      Note: you can widen this sidebar or collapse sections.</p>
      </template>
            Choose a TPMA
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" class="bi bi-info-circle " style="height:1em;width:1em;fill:currentColor;vertical-align:-0.125em;" aria-hidden="true" role="img" ><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"></path>
      <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533L8.93 6.588zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0z"></path></svg>
          </bslib-tooltip>
        </label>
        <div>
          <select id="test-strategy_select" class="shiny-input-select"></select>
          <script type="application/json" data-for="test-strategy_select" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
        </div>
      </div>

