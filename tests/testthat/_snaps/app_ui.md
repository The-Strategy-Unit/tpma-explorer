# ui

    Code
      ui
    Output
      <body class="bslib-page-fill bslib-gap-spacing bslib-flow-mobile html-fill-container bslib-page-navbar has-page-sidebar" style="padding:0px;gap:0px;">
        <nav class="navbar navbar-default navbar-static-top" role="navigation" data-bs-theme="auto">
          <div class="container-fluid">
            <div class="navbar-header">
              <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse-X" data-bs-toggle="collapse" data-bs-target="#navbar-collapse-X">
                <span class="sr-only visually-hidden">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
              </button>
              <span class="navbar-brand">Explore potentially-mitigatable activity data</span>
            </div>
            <div class="navbar-collapse collapse" id="navbar-collapse-X">
              <ul class="nav navbar-nav nav-underline shiny-tab-input" id="page_navbar" data-tabsetid="X">
                <li class="active">
                  <a href="#tab-X-1" data-toggle="tab" data-bs-toggle="tab" data-value="Visualisations">Visualisations</a>
                </li>
                <li>
                  <a href="#tab-X-2" data-toggle="tab" data-bs-toggle="tab" data-value="Information">Information</a>
                </li>
                <li class="bslib-nav-item nav-item form-inline ms-auto">
                  <a href="https://example.com/" target="_blank" class="nav-link">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" class="bi bi-chat-dots " style="height:1em;width:1em;fill:currentColor;vertical-align:-0.125em;" aria-hidden="true" role="img" ><path d="M5 8a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm4 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm3 1a1 1 0 1 0 0-2 1 1 0 0 0 0 2z"></path>
      <path d="m2.165 15.803.02-.004c1.83-.363 2.948-.842 3.468-1.105A9.06 9.06 0 0 0 8 15c4.418 0 8-3.134 8-7s-3.582-7-8-7-8 3.134-8 7c0 1.76.743 3.37 1.97 4.6a10.437 10.437 0 0 1-.524 2.318l-.003.011a10.722 10.722 0 0 1-.244.637c-.079.186.074.394.273.362a21.673 21.673 0 0 0 .693-.125zm.8-3.108a1 1 0 0 0-.287-.801C1.618 10.83 1 9.468 1 8c0-3.192 3.004-6 7-6s7 2.808 7 6c0 3.193-3.004 6-7 6a8.06 8.06 0 0 1-2.088-.272 1 1 0 0 0-.711.074c-.387.196-1.24.57-2.634.893a10.97 10.97 0 0 0 .398-2z"></path></svg>
                    Give feedback
                  </a>
                </li>
              </ul>
            </div>
          </div>
        </nav>
        <div class="html-fill-item html-fill-container">
          <div class="bslib-sidebar-layout bslib-mb-spacing html-fill-item" data-bslib-sidebar-border="false" data-bslib-sidebar-border-radius="false" data-bslib-sidebar-init="TRUE" data-collapsible-desktop="true" data-collapsible-mobile="false" data-open-desktop="open" data-open-mobile="always" data-require-bs-caller="layout_sidebar()" data-require-bs-version="5" style="--_sidebar-width:250px;">
            <div class="main">
              <main class="bslib-page-main bslib-gap-spacing">
                <div class="tab-content" data-tabsetid="X">
                  <div class="tab-pane active" data-value="Visualisations" id="tab-X-1">
                    <div class="card bslib-card bslib-mb-spacing html-fill-container" data-bslib-card-init data-require-bs-caller="card()" data-require-bs-version="5">
                      <div class="card-header bslib-gap-spacing bg-warning">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" class="bi bi-exclamation-triangle " style="height:1em;width:1em;fill:currentColor;vertical-align:-0.125em;" aria-hidden="true" role="img" ><path d="M7.938 2.016A.13.13 0 0 1 8.002 2a.13.13 0 0 1 .063.016.146.146 0 0 1 .054.057l6.857 11.667c.036.06.035.124.002.183a.163.163 0 0 1-.054.06.116.116 0 0 1-.066.017H1.146a.115.115 0 0 1-.066-.017.163.163 0 0 1-.054-.06.176.176 0 0 1 .002-.183L7.884 2.073a.147.147 0 0 1 .054-.057zm1.044-.45a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566z"></path>
      <path d="M7.002 12a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 5.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995z"></path></svg>
                        Warning
                      </div>
                      <div class="card-body bslib-gap-spacing html-fill-item html-fill-container" style="margin-top:auto;margin-bottom:auto;flex:1 1 auto;">
                        This app is in development and its output has not been verified.
                        The information presented here should not be relied on as fact.
                      </div>
                      <script data-bslib-card-init>bslib.Card.initializeAllCards();</script>
                    </div>
                    <bslib-layout-columns class="bslib-grid grid bslib-mb-spacing" col-widths-sm="3,9" data-require-bs-version="5" data-require-bs-caller="layout_columns()">
                      <div class="bslib-grid-item">mod_show_strategy_text</div>
                      <div class="bslib-grid-item">
                        <div class="bslib-grid bslib-mb-spacing html-fill-item" data-require-bs-caller="layout_column_wrap()" data-require-bs-version="5" style="grid-template-columns:repeat(1, minmax(0, 1fr));grid-auto-rows:1fr;--bslib-grid-height:auto;--bslib-grid-height-mobile:auto;gap:0.8rem;">
                          <div class="bslib-grid-item bslib-gap-spacing html-fill-container">mod_plot_rates</div>
                          <div class="bslib-grid-item bslib-gap-spacing html-fill-container">
                            <div class="bslib-grid bslib-mb-spacing html-fill-item" data-require-bs-caller="layout_column_wrap()" data-require-bs-version="5" style="grid-template-columns:repeat(2, minmax(0, 1fr));grid-auto-rows:1fr;--bslib-grid-height:auto;--bslib-grid-height-mobile:auto;">
                              <div class="bslib-grid-item bslib-gap-spacing html-fill-container">mod_table_procedures</div>
                              <div class="bslib-grid-item bslib-gap-spacing html-fill-container">mod_table_diagnoses</div>
                            </div>
                          </div>
                          <div class="bslib-grid-item bslib-gap-spacing html-fill-container">
                            <div class="bslib-grid bslib-mb-spacing html-fill-item" data-require-bs-caller="layout_column_wrap()" data-require-bs-version="5" style="grid-template-columns:repeat(2, minmax(0, 1fr));grid-auto-rows:1fr;--bslib-grid-height:auto;--bslib-grid-height-mobile:auto;">
                              <div class="bslib-grid-item bslib-gap-spacing html-fill-container">mod_plot_age_sex_pyramid</div>
                              <div class="bslib-grid-item bslib-gap-spacing html-fill-container">mod_plot_nee</div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </bslib-layout-columns>
                  </div>
                  <div class="tab-pane" data-value="Information" id="tab-X-2">
                    <bslib-layout-columns class="bslib-grid grid bslib-mb-spacing html-fill-item" data-require-bs-caller="layout_columns()" data-require-bs-version="5">
                      <div class="bslib-grid-item bslib-gap-spacing html-fill-container">
                        <bslib-layout-columns class="bslib-grid grid bslib-mb-spacing html-fill-item" col-widths-sm="12,12" data-require-bs-caller="layout_columns()" data-require-bs-version="5">
                          <div class="bslib-grid-item bslib-gap-spacing html-fill-container">
                            <div class="card bslib-card bslib-mb-spacing bslib-card-input html-fill-item html-fill-container" data-bslib-card-init data-require-bs-caller="card()" data-require-bs-version="5" id="card_purpose">
                              <div class="card-header bslib-gap-spacing">Purpose</div>
                              <div class="card-body bslib-gap-spacing html-fill-item html-fill-container" style="margin-top:auto;margin-bottom:auto;flex:1 1 auto;"><p>View summaries of data for <strong>Types of Potentially-Mitigatable Activity (TPMAs)</strong> for statistical units within different geographical categories.</p>
      </div>
                              <script data-bslib-card-init>bslib.Card.initializeAllCards();</script>
                            </div>
                          </div>
                          <div class="bslib-grid-item bslib-gap-spacing html-fill-container">
                            <div class="card bslib-card bslib-mb-spacing bslib-card-input html-fill-item html-fill-container" data-bslib-card-init data-require-bs-caller="card()" data-require-bs-version="5" id="card_data">
                              <div class="card-header bslib-gap-spacing">Definitions</div>
                              <div class="card-body bslib-gap-spacing html-fill-item html-fill-container" style="margin-top:auto;margin-bottom:auto;flex:1 1 auto;"><p>Visit the New Hospital Programme (NHP) project information website to:</p>
      <ul>
      <li>view definitions of TPMAs related to the activity types of <a href="https://connect.strategyunitwm.nhs.uk/nhp/project_information/modelling_methodology/activity_mitigators/inpatient_activity_mitigators.html">inpatients</a>, <a href="https://connect.strategyunitwm.nhs.uk/nhp/project_information/modelling_methodology/activity_mitigators/outpatient_activity_mitigators.html">outpatients</a> and <a href="https://connect.strategyunitwm.nhs.uk/nhp/project_information/modelling_methodology/activity_mitigators/ae_activity_mitigators.html">A&amp;E</a></li>
      <li>see a <a href="https://connect.strategyunitwm.nhs.uk/nhp/project_information/user_guide/mitigators_lookup.html">TPMA lookup</a>, including names, codes and deprecation status</li>
      </ul>
      </div>
                              <script data-bslib-card-init>bslib.Card.initializeAllCards();</script>
                            </div>
                          </div>
                          <div class="bslib-grid-item bslib-gap-spacing html-fill-container">
                            <div class="card bslib-card bslib-mb-spacing bslib-card-input html-fill-item html-fill-container" data-bslib-card-init data-require-bs-caller="card()" data-require-bs-version="5" id="card_data">
                              <div class="card-header bslib-gap-spacing">Data</div>
                              <div class="card-body bslib-gap-spacing html-fill-item html-fill-container" style="margin-top:auto;margin-bottom:auto;flex:1 1 auto;"><p>Placeholder.</p>
      </div>
                              <script data-bslib-card-init>bslib.Card.initializeAllCards();</script>
                            </div>
                          </div>
                        </bslib-layout-columns>
                      </div>
                      <div class="bslib-grid-item bslib-gap-spacing html-fill-container">
                        <bslib-layout-columns class="bslib-grid grid bslib-mb-spacing html-fill-item" col-widths-sm="12,12" data-require-bs-caller="layout_columns()" data-require-bs-version="5">
                          <div class="bslib-grid-item bslib-gap-spacing html-fill-container">
                            <div class="card bslib-card bslib-mb-spacing bslib-card-input html-fill-item html-fill-container" data-bslib-card-init data-require-bs-caller="card()" data-require-bs-version="5" id="card_navigation">
                              <div class="card-header bslib-gap-spacing">Navigation</div>
                              <div class="card-body bslib-gap-spacing html-fill-item html-fill-container" style="margin-top:auto;margin-bottom:auto;flex:1 1 auto;"><p>First, make selections in the left-hand panel:</p>
      <ol>
      <li>From the <strong>Visualisations</strong> section:
      <ul>
      <li>Select from the <strong>Filter by geography</strong> dropdown to choose a geographical categorisation.</li>
      <li>Select a statistical unit from the <strong>Choose</strong> dropdown to view its data.</li>
      </ul>
      </li>
      <li>From the <strong>Types of potentially mitigatable activity (TPMAs)</strong> section:
      <ul>
      <li>Select from the <strong>Filter by activity type</strong> dropdown to choose from a category of TPMAs.</li>
      <li>Select a TPMA from the <strong>Choose a TPMA</strong> dropdown to view data for that TPMA (your selections will automatically update the content of the <strong>Data</strong> section of the app).</li>
      </ul>
      </li>
      <li>Use the navigation bar at the top to visit different sections of the app. Visit the:
      <ul>
      <li><strong>Information</strong> tab (current tab) for background information and instructions.</li>
      <li><strong>Visualisations</strong> tab to view a description of the selected TPMA</li>
      </ul>
      </li>
      </ol>
      </div>
                              <script data-bslib-card-init>bslib.Card.initializeAllCards();</script>
                            </div>
                          </div>
                          <div class="bslib-grid-item bslib-gap-spacing html-fill-container">
                            <div class="card bslib-card bslib-mb-spacing bslib-card-input html-fill-item html-fill-container" data-bslib-card-init data-require-bs-caller="card()" data-require-bs-version="5" id="card_how_to_use">
                              <div class="card-header bslib-gap-spacing">Interface</div>
                              <div class="card-body bslib-gap-spacing html-fill-item html-fill-container" style="margin-top:auto;margin-bottom:auto;flex:1 1 auto;"><p>You can hover over the <strong>information symbol</strong> (<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" class="bi bi-info-circle " style="height:1em;width:1em;fill:currentColor;vertical-align:-0.125em;" aria-hidden="true" role="img" ><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"></path> <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533L8.93 6.588zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0z"></path></svg>) for further information about a visualisation.</p>
      <p>To maximise the space for visualisations, you can:</p>
      <ul>
      <li>click the <strong>expand</strong> button (<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" class="bi bi-chevron-expand " style="height:1em;width:1em;fill:currentColor;vertical-align:-0.125em;" aria-hidden="true" role="img" ><path fill-rule="evenodd" d="M3.646 9.146a.5.5 0 0 1 .708 0L8 12.793l3.646-3.647a.5.5 0 0 1 .708.708l-4 4a.5.5 0 0 1-.708 0l-4-4a.5.5 0 0 1 0-.708zm0-2.292a.5.5 0 0 0 .708 0L8 3.207l3.646 3.647a.5.5 0 0 0 .708-.708l-4-4a.5.5 0 0 0-.708 0l-4 4a.5.5 0 0 0 0 .708z"></path></svg>) in the lower-right of a plot to expand to full screen</li>
      <li>collapse the sidebar by clicking the <strong>toggle sidebar</strong> chevron <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" class="bi bi-chevron-left " style="height:1em;width:1em;fill:currentColor;vertical-align:-0.125em;" aria-hidden="true" role="img" ><path fill-rule="evenodd" d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0z"></path></svg> in its upper-right corner</li>
      </ul>
      </div>
                              <script data-bslib-card-init>bslib.Card.initializeAllCards();</script>
                            </div>
                          </div>
                        </bslib-layout-columns>
                      </div>
                    </bslib-layout-columns>
                  </div>
                </div>
              </main>
            </div>
            <aside id="bslib-sidebar-X" class="sidebar" hidden>
              <div class="sidebar-content bslib-gap-spacing">
                <div class="accordion bslib-accordion-input" data-require-bs-caller="accordion()" data-require-bs-version="5" id="sidebar_accordion">
                  <div class="accordion-item" data-value="Datasets">
                    <div class="accordion-header">
                      <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#bslib-accordion-panel-X" aria-expanded="false" aria-controls="bslib-accordion-panel-X">
                        <div class="accordion-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" class="bi bi-table " style="height:1em;width:1em;fill:currentColor;vertical-align:-0.125em;" aria-hidden="true" role="img" ><path d="M0 2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V2zm15 2h-4v3h4V4zm0 4h-4v3h4V8zm0 4h-4v3h3a1 1 0 0 0 1-1v-2zm-5 3v-3H6v3h4zm-5 0v-3H1v2a1 1 0 0 0 1 1h3zm-4-4h4V8H1v3zm0-4h4V4H1v3zm5-3v3h4V4H6zm4 4H6v3h4V8z"></path></svg></div>
                        <div class="accordion-title">Datasets</div>
                      </button>
                    </div>
                    <div id="bslib-accordion-panel-X" class="accordion-collapse collapse">
                      <div class="accordion-body">
                        mod_select_geography
                        mod_select_provider
                      </div>
                    </div>
                  </div>
                  <div class="accordion-item" data-value="Types of Potentially Mitigatable Activity (TPMAs)">
                    <div class="accordion-header">
                      <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#bslib-accordion-panel-X" aria-expanded="false" aria-controls="bslib-accordion-panel-X">
                        <div class="accordion-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" class="bi bi-hospital " style="height:1em;width:1em;fill:currentColor;vertical-align:-0.125em;" aria-hidden="true" role="img" ><path d="M8.5 5.034v1.1l.953-.55.5.867L9 7l.953.55-.5.866-.953-.55v1.1h-1v-1.1l-.953.55-.5-.866L7 7l-.953-.55.5-.866.953.55v-1.1h1ZM13.25 9a.25.25 0 0 0-.25.25v.5c0 .138.112.25.25.25h.5a.25.25 0 0 0 .25-.25v-.5a.25.25 0 0 0-.25-.25h-.5ZM13 11.25a.25.25 0 0 1 .25-.25h.5a.25.25 0 0 1 .25.25v.5a.25.25 0 0 1-.25.25h-.5a.25.25 0 0 1-.25-.25v-.5Zm.25 1.75a.25.25 0 0 0-.25.25v.5c0 .138.112.25.25.25h.5a.25.25 0 0 0 .25-.25v-.5a.25.25 0 0 0-.25-.25h-.5Zm-11-4a.25.25 0 0 0-.25.25v.5c0 .138.112.25.25.25h.5A.25.25 0 0 0 3 9.75v-.5A.25.25 0 0 0 2.75 9h-.5Zm0 2a.25.25 0 0 0-.25.25v.5c0 .138.112.25.25.25h.5a.25.25 0 0 0 .25-.25v-.5a.25.25 0 0 0-.25-.25h-.5ZM2 13.25a.25.25 0 0 1 .25-.25h.5a.25.25 0 0 1 .25.25v.5a.25.25 0 0 1-.25.25h-.5a.25.25 0 0 1-.25-.25v-.5Z"></path>
      <path d="M5 1a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v1a1 1 0 0 1 1 1v4h3a1 1 0 0 1 1 1v7a1 1 0 0 1-1 1H1a1 1 0 0 1-1-1V8a1 1 0 0 1 1-1h3V3a1 1 0 0 1 1-1V1Zm2 14h2v-3H7v3Zm3 0h1V3H5v12h1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3Zm0-14H6v1h4V1Zm2 7v7h3V8h-3Zm-8 7V8H1v7h3Z"></path></svg></div>
                        <div class="accordion-title">Types of Potentially Mitigatable Activity (TPMAs)</div>
                      </button>
                    </div>
                    <div id="bslib-accordion-panel-X" class="accordion-collapse collapse">
                      <div class="accordion-body">mod_select_strategy</div>
                    </div>
                  </div>
                </div>
              </div>
            </aside>
            <button class="collapse-toggle" type="button" title="Toggle sidebar" aria-expanded="true" aria-controls="bslib-sidebar-X"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" class="bi bi-chevron-left collapse-icon" style="height:;width:;fill:currentColor;vertical-align:-0.125em;" aria-hidden="true" role="img" ><path fill-rule="evenodd" d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0z"></path></svg></button>
            <script data-bslib-sidebar-init>bslib.Sidebar.initCollapsibleAll()</script>
          </div>
        </div>
      </body>

