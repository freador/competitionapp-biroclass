require "application_system_test_case"

class RankingsTest < ApplicationSystemTestCase
  setup do
    @ranking = rankings(:one)
  end

  test "visiting the index" do
    visit rankings_url
    assert_selector "h1", text: "Rankings"
  end

  test "should create ranking" do
    visit rankings_url
    click_on "New ranking"

    fill_in "Competition", with: @ranking.competition_id
    fill_in "Participant", with: @ranking.participant_id
    fill_in "Position", with: @ranking.position
    fill_in "Total score", with: @ranking.total_score
    click_on "Create Ranking"

    assert_text "Ranking was successfully created"
    click_on "Back"
  end

  test "should update Ranking" do
    visit ranking_url(@ranking)
    click_on "Edit this ranking", match: :first

    fill_in "Competition", with: @ranking.competition_id
    fill_in "Participant", with: @ranking.participant_id
    fill_in "Position", with: @ranking.position
    fill_in "Total score", with: @ranking.total_score
    click_on "Update Ranking"

    assert_text "Ranking was successfully updated"
    click_on "Back"
  end

  test "should destroy Ranking" do
    visit ranking_url(@ranking)
    accept_confirm { click_on "Destroy this ranking", match: :first }

    assert_text "Ranking was successfully destroyed"
  end
end
