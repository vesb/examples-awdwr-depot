class RenamePayTypeToPaymentTypeInOrders < ActiveRecord::Migration[5.2]
  def change
    rename_column :orders, :pay_type, :payment_type
  end
end
