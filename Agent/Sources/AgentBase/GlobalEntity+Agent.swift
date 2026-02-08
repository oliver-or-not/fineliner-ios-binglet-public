// MARK: - Module Dependency

import Spectrum

// MARK: - Body

extension GlobalEntity {

    public enum Agent {

        public protocol Interface: GlobalEntity.Interface {

            /// 식별 수단.
            nonisolated var designation: AgentDesignation { get }

            /// 활성 수준.
            var activationLevel: ActivationLevel { get async }

            /// 활성 수준을 설정한다.
            func setActivationLevel(_ activationLevel: ActivationLevel) async
        }

        public enum ActivationLevel: Int, Sendable {

            case inactive = 0
            case active = 1

            public var significance: Int {
                self.rawValue
            }
        }
    }
}
