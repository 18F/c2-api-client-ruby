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
      if ENV.fetch('C2_PROPOSAL_ID')
        client = get_c2_client
        proposal_id = ENV.fetch('C2_PROPOSAL_ID').to_i
        resp = client.get("proposals/#{proposal_id}")

        expect(resp.status).to eq(200)
        expect(resp.body.id).to eq(proposal_id)
      end
    end
  end

  describe "post" do
    it "creates a proposal" do
      client = get_c2_client
      payload = {
        gsa18f_procurement: {
          product_name_and_description: "some stuff",
          cost_per_unit: 123.00,
          quantity: 1,
          justification: "because because because",
          link_to_product: "18f.gov",
          purchase_type: "Software"
        }
      }
      resp = client.post("proposals", payload)

      expect(resp.status).to eq(200)
      expect(resp.body.client_data.link_to_product).to eq "18f.gov"
    end
  end
end
