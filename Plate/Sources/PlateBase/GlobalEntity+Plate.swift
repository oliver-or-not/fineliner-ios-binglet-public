// MARK: - Module Dependency

import Spectrum

// MARK: - Body

extension GlobalEntity {

    /// 화면 전체를 차지할 수 있는 뷰.
    public enum Plate {

        public protocol Interface: GlobalEntity.Interface {

            /// 식별 수단.
            nonisolated var designation: PlateDesignation { get }
        }
    }
}
