module Arangodm::Query
  # Base for different query types
  class Base
    attr_reader :runner, :db

    def initialize(db:, runner: Arangodm::Query::Runner.new(db: db))
      @runner = runner
      @db = db
      @text = ''
    end

    def for(var, on:)
      @text += "FOR #{var} IN #{on} "
      @text += yield(var) if block_given?
      self
    end

    def insert(vals, into:)
      @text += "INSERT #{vals} INTO #{into} "
      @text += yield if block_given?
      self
    end

    def filter
      @text += "FILTER "
      @text += yield
      self
    end

    def collect(data, into:, count: false)
      # data: {year: "DATE_YEAR(user.dateRegistered)", month: 5}
      @text += "COLLECT #{data.map{ |k, v| "#{k} = #{v}"}.join(', ')} "
      @text += "WITH COUNT " if count
      @text += "INTO #{into} "
      @text += yield(data.keys) if block_given?
      self
    end

    def collect_aggregate(data)
      @text += "COLLECT AGGREGATE #{data.map{ |k, v| "#{k} = #{v}"}.join(', ')} "
      @text += yield(data.keys) if block_given?
      self
    end

    def cond(val1, op, val2)
      @text += "#{val1} #{op} #{val2} "
      self
    end

    def eq?(val1, val2)
      cond(val1, '==', val2)
    end

    def gte?(val1, val2)
      cond(val1, '>=', val2)
    end

    def lte?(val1, val2)
      cond(val1, '<=', val2)
    end

    def lt?(val1, val2)
      cond(val1, '<', val2)
    end

    def gt?(val1, val2)
      cond(val1, '>', val2)
    end

    def update(cond, with:, on:)
      @text += "UPDATE #{cond} WITH #{with} IN #{on} "
      self
    end

    def replace(cond, with:, on:)
      @text += "REPLACE #{cond} WITH #{with} IN #{on} "
      self
    end

    def remove(cond, on:)
      @text += "REMOVE #{cond} IN #{on} "
      self
    end

    def sort(*vals)
      @text += "SORT #{vals.join(', ')} "
    end

    def return(val)
      @text += "RETURN #{val} "
      self
    end
  end
end
