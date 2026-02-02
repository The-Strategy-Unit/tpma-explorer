# ui

    Code
      ui
    Output
      <div class="container-fluid">
        <div class="card bslib-card bslib-mb-spacing html-fill-item html-fill-container" data-bslib-card-init data-full-screen="false" data-require-bs-caller="card()" data-require-bs-version="5" id="bslib-card-X">
          <div class="card-header">
            National Elicitation Exercise (NEE) estimate
            <bslib-tooltip placement="right" bsOptions="[]" data-require-bs-version="5" data-require-bs-caller="tooltip()">
              <template><p>Summarised expert predictions from the National Elicitation Exercise (NEE).
      The dot is the mean value and the horizontal bar is the 10% to 90% interval.
      Predictions were for 2039/40.
      Not all TPMAs were part of that exercise.</p>
      </template>
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" class="bi bi-info-circle " style="height:1em;width:1em;fill:currentColor;vertical-align:-0.125em;" aria-hidden="true" role="img" ><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"></path>
      <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533L8.93 6.588zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0z"></path></svg>
            </bslib-tooltip>
          </div>
          <div class="card-body bslib-gap-spacing html-fill-item html-fill-container" style="margin-top:auto;margin-bottom:auto;flex:1 1 auto;">
            <div data-spinner-id="spinner-f7ffd162cbe6637ebd6251ac7e696383" class="shiny-spinner-output-container shiny-spinner-hideui">
              <div class="load-container shiny-spinner-hidden load1">
                <div id="spinner-f7ffd162cbe6637ebd6251ac7e696383" class="loader">Loading...</div>
              </div>
              <div class="shiny-plot-output html-fill-item" id="test-nee" style="width:100%;height:400px;"></div>
            </div>
          </div>
          <bslib-tooltip placement="auto" bsOptions="[]" data-require-bs-version="5" data-require-bs-caller="tooltip()">
            <template>Expand</template>
            <button aria-expanded="false" aria-label="Expand card" class="bslib-full-screen-enter badge rounded-pill"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" style="height:1em;width:1em;fill:currentColor;" aria-hidden="true" role="img"><path d="M20 5C20 4.4 19.6 4 19 4H13C12.4 4 12 3.6 12 3C12 2.4 12.4 2 13 2H21C21.6 2 22 2.4 22 3V11C22 11.6 21.6 12 21 12C20.4 12 20 11.6 20 11V5ZM4 19C4 19.6 4.4 20 5 20H11C11.6 20 12 20.4 12 21C12 21.6 11.6 22 11 22H3C2.4 22 2 21.6 2 21V13C2 12.4 2.4 12 3 12C3.6 12 4 12.4 4 13V19Z"/></svg></button>
          </bslib-tooltip>
          <script data-bslib-card-init>bslib.Card.initializeAllCards();</script>
        </div>
      </div>

