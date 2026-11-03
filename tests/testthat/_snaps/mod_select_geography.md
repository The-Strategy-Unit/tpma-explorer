# ui

    Code
      ui
    Output
      <div id="test-geography_select" class="form-group shiny-input-radiogroup shiny-input-container" role="radiogroup" aria-labelledby="test-geography_select-label">
        <label class="control-label" id="test-geography_select-label" for="test-geography_select">
          <div class="mb-2">
            <bslib-tooltip placement="auto" bsOptions="[]" data-require-bs-version="5" data-require-bs-caller="tooltip()">
              <template>
                <div style="text-align: left;"><p>Choose the geography for which you want to select a smaller subunit.</p>
      <p>Note: you can widen this sidebar or collapse sections.</p>
      </div>
              </template>
              Explore data for:
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" class="bi bi-info-circle " style="height:1em;width:1em;fill:currentColor;vertical-align:-0.125em;" aria-hidden="true" role="img" ><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"></path>
      <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533L8.93 6.588zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0z"></path></svg>
            </bslib-tooltip>
          </div>
        </label>
        <div class="shiny-options-group">
          <div class="radio">
            <label>
              <input type="radio" name="test-geography_select" value="la" checked="checked"/>
              <span>Local Authorities (LAs)</span>
            </label>
          </div>
          <div class="radio">
            <label>
              <input type="radio" name="test-geography_select" value="nhp"/>
              <span>NHS provider trusts</span>
            </label>
          </div>
          <div class="radio">
            <label>
              <input type="radio" name="test-geography_select" value="icb"/>
              <span>Integrated Care Boards (ICBs)</span>
            </label>
          </div>
        </div>
      </div>

