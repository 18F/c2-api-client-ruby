require 'spec_helper'

describe C2::Client do
  describe "initialize" do
    it "defaults" do
      client = get_c2_client
      expect(client)
    end
  end

  describe "get" do
    it "fetches a proposal" do
      client = get_c2_client
      proposal_id = ENV.fetch('C2_PROPOSAL_ID', 1)
      resp = client.get("proposals/#{proposal_id}")
      expect(resp.status).to eq(200)
      expect(resp.body.id).to eq(proposal_id)
    end
  end
end
