defmodule ApolloIo.Organization do
  alias ApolloIo.{Account, Helpers, RateLimit, Request}

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t() | nil,
          website_url: String.t(),
          blog_url: String.t() | nil,
          angellist_url: String.t() | nil,
          linkedin_url: String.t() | nil,
          twitter_url: String.t() | nil,
          facebook_url: String.t() | nil,
          languages: list,
          alexa_ranking: number,
          phone: String.t() | nil,
          linkedin_uid: integer,
          publicly_traded_symbol: String.t() | nil,
          publicly_traded_exchange: String.t() | nil,
          logo_url: String.t(),
          crunchbase_url: String.t() | nil,
          primary_domain: String.t(),
          persona_counts: map,
          industry: String.t(),
          keywords: list,
          estimated_num_employees: integer,
          snippets_loaded: boolean,
          industry_tag_id: String.t(),
          retail_location_count: integer,
          raw_address: String.t(),
          street_address: String.t(),
          city: String.t(),
          state: String.t(),
          postal_code: String.t(),
          country: String.t(),
          owned_by_organization_id: String.t() | nil,
          suborganizations: list,
          num_suborganizations: integer,
          seo_description: String.t(),
          short_description: String.t(),
          total_funding: number | nil,
          total_funding_printed: number | nil,
          latest_funding_round_date: Date.t() | nil,
          latest_funding_stage: String.t() | nil,
          funding_events: list,
          technology_names: list,
          current_technologies: list,
          account_id: String.t(),
          account: Account.t()
        }

  @derive Jason.Encoder
  @derive JSON.Encoder
  use ApolloIo.Accessible

  defstruct [
    :id,
    :name,
    :website_url,
    :blog_url,
    :angellist_url,
    :linkedin_url,
    :twitter_url,
    :facebook_url,
    :languages,
    :alexa_ranking,
    :phone,
    :linkedin_uid,
    :publicly_traded_symbol,
    :publicly_traded_exchange,
    :logo_url,
    :crunchbase_url,
    :primary_domain,
    :persona_counts,
    :industry,
    :keywords,
    :estimated_num_employees,
    :snippets_loaded,
    :industry_tag_id,
    :retail_location_count,
    :raw_address,
    :street_address,
    :city,
    :state,
    :postal_code,
    :country,
    :owned_by_organization_id,
    :suborganizations,
    :num_suborganizations,
    :seo_description,
    :short_description,
    :total_funding,
    :total_funding_printed,
    :latest_funding_round_date,
    :latest_funding_stage,
    :funding_events,
    :technology_names,
    :current_technologies,
    :account_id,
    :account
  ]

  @organization_match_url "/organizations/enrich"
  # /organizations/search is grantable on a scoped (least-privilege) key, unlike
  # /mixed_companies/search which is master-key-only. Both return an
  # "organizations" array with the same shape for our name->domain use.
  @organization_search_url "/organizations/search"

  @doc """
  Query the endpoint.
  Accepted values:
  - domain (required)
  ref: https://apolloio.github.io/apollo-api-docs/?shell#organization-enrichment

  Calling this function with a string is supported but discouraged.
  """
  @spec organization_enrich(Keyword.t() | String.t()) ::
          {:ok, __MODULE__.t(), RateLimit.t()} | {:error, Request.error()}
  def organization_enrich(domain) when is_binary(domain) do
    organization_enrich(domain: domain)
  end

  def organization_enrich(opts) do
    opts = opts |> Enum.into(%{})

    case Request.get(@organization_match_url, opts) do
      {:ok, body, headers} ->
        {:ok, cast_to_struct(body), Helpers.parse_headers(headers)}

      {:error, error} ->
        {:error, error}
    end
  end

  def organization_search(opts) do
    opts = opts |> Enum.into(%{})
    Request.get(@organization_search_url, opts)
  end

  defp cast_to_struct(body) do
    Helpers.map_to_struct(body["organization"], __MODULE__)
    |> Map.update!(:account, &Helpers.map_to_struct(&1, Account))
  end
end
