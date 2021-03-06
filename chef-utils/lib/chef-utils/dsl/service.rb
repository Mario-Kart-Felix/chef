#
# Copyright:: Copyright 2018-2019, Chef Software Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_relative "../internal"
require_relative "train_helpers"

module ChefUtils
  module DSL
    # NOTE: these are mixed into the service resource+providers specifically and deliberately not
    # injected into the global namespace
    module Service
      include Internal
      include TrainHelpers

      # Returns if debian's old rc.d manager is installed (not necessarily the primary init system).
      #
      # @return [Boolean]
      #
      def debianrcd?
        file_exist?("/usr/sbin/update-rc.d")
      end

      # Returns if debian's old invoke rc.d manager is installed (not necessarily the primary init system).
      #
      # @return [Boolean]
      #
      def invokercd?
        file_exist?("/usr/sbin/invoke-rc.d")
      end

      # Returns if upstart is installed (not necessarily the primary init system).
      #
      # @return [Boolean]
      #
      def upstart?
        file_exist?("/sbin/initctl")
      end

      # Returns if insserv is installed (not necessarily the primary init system).
      #
      # @return [Boolean]
      #
      def insserv?
        file_exist?("/sbin/insserv")
      end

      # Returns if redhat's init system is installed (not necessarily the primary init system).
      #
      # @return [Boolean]
      #
      def redhatrcd?
        file_exist?("/sbin/chkconfig")
      end

      def service_script_exist?(type, script)
        case type
        when :initd
          file_exist?("/etc/init.d/#{script}")
        when :upstart
          file_exist?("/etc/init/#{script}.conf")
        when :xinetd
          file_exist?("/etc/xinetd.d/#{script}")
        when :etc_rcd
          file_exist?("/etc/rc.d/#{script}")
        when :systemd
          file_exist?("/etc/init.d/#{script}") ||
            ChefUtils::DSL::Introspection.has_systemd_service_unit?(script) ||
            ChefUtils::DSL::Introspection.has_systemd_unit?(script)
        else
          raise ArgumentError, "type of service must be one of :initd, :upstart, :xinetd, :etc_rcd, or :systemd"
        end
      end

      extend self
    end
  end
end
