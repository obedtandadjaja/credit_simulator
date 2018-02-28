module V1::SharedParams
  extend Grape::API::Helpers

  # time constraint params
  params :period do
    optional :start_date,
             type: String,
             documentation: { description: "start date in epoch format" }

    optional :end_date,
             type: String,
             documentation: { description: "end date in epoch format" }
  end

  # ordering param
  params :order do |options|
    optional :order_by,
             type: Symbol,
             values: options[:order_by],
             default: options[:default_order_by],
             documentation: { description: "column name to sort" }

    optional :order,
             type: Symbol,
             values: %i(asc desc),
             default: options[:default_order],
             documentation: { description: "asc or desc" }
  end
end
