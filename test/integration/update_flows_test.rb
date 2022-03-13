require "test_helper"

class UpdateFlowsTest < ActionDispatch::IntegrationTest
  test "GET /covid/update is recognized" do
    assert_recognizes(
      { controller: "updates", action: "show" },
      { path: "covid/update", method: :get }
    )
  end

  test "GET /covid/update responds 200" do
    get covid_update_path

    assert_response :ok
  end

  test "GET /covid/update responds a number" do
    an_update = updates(:one)

    get covid_update_path
    response = JSON.parse @response.body

    assert_equal an_update.last_load_date.to_s, response["lastLoadDate"]
    assert_equal an_update.updated_records, response["updatedRecords"]
  end
end
