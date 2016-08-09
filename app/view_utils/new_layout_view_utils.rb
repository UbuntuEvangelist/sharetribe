module NewLayoutViewUtils
  extend ActionView::Helpers::TranslationHelper

  Feature = EntityUtils.define_builder(
    [:title, :string, :mandatory],
    [:name, :symbol, :mandatory],
    [:enabled_for_user, :bool, :mandatory],
    [:enabled_for_community, :bool, :mandatory]
  )

  FEATURES = [
    { title: t("admin.communities.new_layout.new_topbar"),
      name: :topbar_v1
    },
    { title: "Foo",
      name: :foo
    },
    { title: "Bar",
      name: :bar
    }
  ]

  module_function

  def features
    FEATURES.map { |f|
      Feature.build({
        title: f[:title],
        name: f[:name],
        enabled_for_user: FeatureFlagHelper.feature_enabled_for_user?(f[:name]),
        enabled_for_community: FeatureFlagHelper.feature_enabled_for_community?(f[:name])
      })
    }
  end

  # Takes a map of features
  # {
  #  "foo" => "true",
  #  "bar" => "true",
  # }
  # and returns the keys as symbols from the entries
  # that hold value "true".
  def enabled_features(feature_params)
    feature_params.select { |key, value| value == "true"}
      .keys
      .map(&:to_sym)
  end

  # From the list of features, selects the ones
  # that are disabled, ie. not included in the
  # list of enabled features.
  def resolve_disabled(enabled)
    FEATURES.map { |f| f[:name]}
      .select { |f| !enabled.include?(f) }
  end
end
